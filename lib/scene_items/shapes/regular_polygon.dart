import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:drender/scene_items/scene_item.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import '../../key.dart';
import '../../process_items.dart';

class RegularPolygonItem extends SceneItem {
  // TODO: shouldnt the "from" format *not* have named parameters?
  RegularPolygonItem.fromSideLength({
    required double sideLength,
    required Color colour,
    required int n,
  }) : this.fromRadius(
            radius: sideLength / (2 * sin(2 * pi / n / 2)),
            colour: colour,
            n: n);

  RegularPolygonItem.fromRadius({
    required double radius,
    required Color colour,
    required int n,
  })  : assert(n >= 3, 'Polygon must have ≥ 3 sides ($n given)'),
        assert(radius > 0, 'Radius must be positive ($radius given)'),
        _radius = radius,
        _colour = colour,
        _numSides = n;

  final Color _colour;
  final double _radius;
  final int _numSides;

  @override
  List<ProcessItem> compile() {
    final angleDelta = 2 * pi / _numSides;

    List<Vector3> vertices = [
      for (double i = pi / _numSides; i < 2 * pi; i += angleDelta)
        Vector3(-sin(i), cos(i), 0) * _radius
    ].reversed.toList();

    List<TriProcessItem> tris = [
      for (int i = 0; i < _numSides - 2; i++)
        TriProcessItem(
          vertices: (vertices[0], vertices[i + 1], vertices[i + 2]),
          // colour: _colour,
          colour: Color.lerp(_colour, Colors.black, i / _numSides)!,
        )
    ];
    return tris;
  }
}
