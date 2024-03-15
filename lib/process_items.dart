import 'dart:ui';

import 'package:drender/camera.dart';
import 'package:vector_math/vector_math.dart';

import 'extensions.dart';
import 'key.dart';
import 'projection.dart';
import 'render_items.dart';

sealed class ProcessItem {
  DrenKey? get key;

  List<RenderItem> compile(
    DrenCamera camera,
  );

  Vector3 get midpoint;

  void sort(ProcessItem rTree, DrenCamera camera);

  /// Removes and re-formats polygons for performance
  /// - Removes tris which face away from the camera
  /// - Removes tris which are behind the camera
  ///
  /// Returns a list of DrenderTree objects to replace this one.
  /// - No optimisation will return itself in a list.
  /// - A removed tri will be an empty list
  /// - A tri split into multiple will be several objects in a list.
  ///
  /// TODO: find out if optimise or sort first is faster
  List<ProcessItem> optimise(DrenCamera camera);
}

/// A SLRG. Contains a list of other
class LayerProcessItem extends ProcessItem {
  LayerProcessItem({
    this.key,
    required this.children,
  });

  @override
  DrenKey? key;
  List<ProcessItem> children;

  // TODO: implement this better
  @override
  Vector3 get midpoint =>
      children.map((e) => e.midpoint).reduce((c, e) => c + e) /
      children.length.toDouble();

  @override
  List<RenderItem> compile(DrenCamera camera) {
    return children.map((child) => child.compile(camera)).flatten().toList();
  }

  // TODO: implement
  @override
  ProcessItem sort(ProcessItem rTree, DrenCamera camera) {
    // If child key matches child key of similarTree, pass that subtree down.
    return this;
  }

  @override
  List<ProcessItem> optimise(DrenCamera camera) {
    final List<ProcessItem> newChildren = children
        .map((e) => e.optimise(camera))
        .flatten()
        .toList();

    if (newChildren.length <= 1) {
      return newChildren;
    } else {
      children = newChildren;
      return [this];
    }
  }
}

class TriProcessItem extends ProcessItem {
  TriProcessItem({
    this.key,
    required this.vertices,
    required this.colour,
  });

  @override
  DrenKey? key;
  (Vector3, Vector3, Vector3) vertices;
  Color colour;

  @override
  Vector3 get midpoint => vertices.toList.reduce((c, x) => c + x) / 3;

  @override
  List<RenderTri> compile(DrenCamera camera) {
    return [
      RenderTri(
        vertices: vertices.map((v) => project3DTo2D(v, camera)),
        colour: colour,
      )
    ];
  }

  @override
  void sort(ProcessItem rTree, DrenCamera camera) {}

  @override
  List<ProcessItem> optimise(DrenCamera camera) {
    final cameraPlane = camera.plane;

    // If tri is completely behind the camera, delete.
    // TODO: check using a plane slightly in front. becomes view frustum culling ish
    // TODO: Make this culling distance a constant
    if (vertices.toList.every((vertex) => vertex.behind(cameraPlane.planeInFrontAlongNormal(0.1)))) {
      print('deleted: all behind camera');
      return [];
    }

    // If tri faces away from the camera, delete.
    if (camera.position.behind(vertices.plane)) {
      print('deleted: facing away');
      return [];
    }

    if (vertices.intersectsPlane(cameraPlane)) {
      // TODO: i think it is infinitely splitting
      // either have an 'already split' flag, or I'm going to need to
      // think about consistency of 'in front', 'on line', and 'behind'.
      // I've been treating in front/behind as XOR vals. May need some level of error
      // margin, and if a tri's vertex lies 'on' a plane then it doesn't count as
      // an intersection.
      // Either way I think I'll need to implement both. The more conscious
      // handling of on/off line is important for code quality. But having a
      // flag for 'already split' to prevent infinite recursion will still be
      // necessary given the uncertain nature of floats and epsilon comparisons.
      // TODO: best guess is that intersects plane is not stable (float err')

      // FLICKERING:
      // It's because even though the tri is being clipped, the points are *just*
      // one the plane, so the projection is flipping between the two sides.
      print('split: crosses camera plane');
      // TODO: remove splitOnCameraPlane now that we have constant
      // TODO: make this forward split distance a constant
      final (tri1, tri2!, tri3!) = vertices.splitOnPlane(cameraPlane.planeInFrontAlongNormal(0.05));
      final tris = [tri1, tri2, tri3]
          .map((tri) => TriProcessItem(vertices: tri, colour: colour))
          .toList();
      return LayerProcessItem(children: tris)
          .optimise(camera);
    }



    // Otherwise, return as normal.
    return [this];
  }
}
