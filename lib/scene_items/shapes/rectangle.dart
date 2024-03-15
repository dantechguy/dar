import 'dart:ui';

import 'package:drender/key.dart';
import 'package:drender/scene_items/modifiers/scale.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:drender/scene_items/shapes/square.dart';
import 'package:vector_math/vector_math.dart';

import '../../process_items.dart';

class RectangleItem extends SceneItem {
  RectangleItem.fromLengths({
    required double x,
    required double y,
    required Color colour,
  })  : _lengthX = x,
        _lengthY = y,
        _colour = colour;

  final Color _colour;
  final double _lengthX;
  final double _lengthY;

  @override
  List<ProcessItem> compile() {
    return ScaleItem.vector(
      scale: Vector3(_lengthX, _lengthY, 1),
      child: SquareItem(colour: _colour, sideLength: 1),
    ).compile();
  }
}
