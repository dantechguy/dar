import 'dart:ui';

import 'package:drender/key.dart';
import 'package:drender/process_items.dart';
import 'package:drender/scene_items/modifiers/scale.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:drender/scene_items/shapes/cube.dart';
import 'package:vector_math/vector_math.dart';

class CuboidItem extends SceneItem {
  CuboidItem.fromLengths({
    required double x,
    required double y,
    required double z,
    required Color colour,
  })  : _lengthX = x,
        _lengthY = y,
        _lengthZ = z,
        _colour = colour;

  final Color _colour;
  final double _lengthX;
  final double _lengthY;
  final double _lengthZ;

  @override
  List<ProcessItem> compile() {
    return ScaleItem.vector(
      scale: Vector3(_lengthX, _lengthY, _lengthZ),
      child: CubeItem.fromSize(
        size: 1,
        colour: _colour,
      ),
    ).compile();
  }
}
