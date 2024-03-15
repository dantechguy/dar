import 'dart:math';

import 'package:drender/scene_items/modifiers/transform.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:vector_math/vector_math.dart';

import '../../process_items.dart';

enum CartesianAxis {
  positiveX(),
  negativeX(),
  positiveY(),
  negativeY(),
  positiveZ(),
  negativeZ();

  const CartesianAxis();

  Vector3 get unitVector => switch (this) {
        CartesianAxis.positiveX => Vector3(1, 0, 0),
        CartesianAxis.negativeX => Vector3(-1, 0, 0),
        CartesianAxis.positiveY => Vector3(0, 1, 0),
        CartesianAxis.negativeY => Vector3(0, -1, 0),
        CartesianAxis.positiveZ => Vector3(0, 0, 1),
        CartesianAxis.negativeZ => Vector3(0, 0, -1),
      };
}

// Allow Quaternion rotationFromPosZ, pointAndRotate, and CartesianAxis

class RotateItem extends SceneItem {
  RotateItem.byQuaternion({
    required Quaternion rotate,
    required SceneItem child,
  })  : _rotation = rotate.clone(),
        _child = child;

  RotateItem.aroundAxis({
    required CartesianAxis axis,
    required double rotation,
    required SceneItem child,
  })  : _rotation = Quaternion.axisAngle(axis.unitVector, rotation),
        _child = child;

  RotateItem.flip({
    required Vector3 axis,
    required SceneItem child,
}) : _rotation = Quaternion.axisAngle(axis, pi),
  _child = child;

  final SceneItem _child;
  final Quaternion _rotation;

  @override
  List<ProcessItem> compile() {
    return TransformItem.fromSRT(
      rotate: _rotation,
      child: _child,
    ).compile();
  }
}
