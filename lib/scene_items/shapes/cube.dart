import 'dart:math';
import 'dart:ui';

import 'package:drender/extensions.dart';
import 'package:drender/process_items.dart';
import 'package:drender/scene_items/modifiers/rotate.dart';
import 'package:drender/scene_items/modifiers/translate.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:drender/scene_items/shapes/square.dart';
import 'package:vector_math/vector_math.dart';

import '../../key.dart';

// Use 'Square'

class CubeItem extends SceneItem {
  CubeItem.fromSize({
    required double size,
    required Color colour,
    Map<CartesianAxis, Color> faceColours = const {},
  })  : _colour = colour,
        _sideLength = size,
        _faceColours = faceColours;


  final double _sideLength;
  final Color _colour;
  final Map<CartesianAxis, Color> _faceColours;

  @override
  List<ProcessItem> compile() {
    final List<(CartesianAxis, double)> rotations = [
      (CartesianAxis.positiveX, pi / 2),
      (CartesianAxis.positiveX, -pi / 2),
      (CartesianAxis.positiveY, pi / 2),
      (CartesianAxis.positiveY, -pi / 2),
      (CartesianAxis.positiveY, pi),
      (CartesianAxis.positiveY, 0),
    ];
    final List<SceneItem> faces = [
      for (final (axis, rotation) in rotations)
        RotateItem.aroundAxis(
          axis: axis,
          rotation: rotation,
          child: TranslateItem.fromVector(
            translate: Vector3(0, 0, _sideLength/2),
            child: SquareItem(
              colour: _faceColours[axis] ?? _colour,
              sideLength: _sideLength,
            ),
          ),
        )
    ];
    return faces.map((e) => e.compile()).flatten().toList();
  }
}
