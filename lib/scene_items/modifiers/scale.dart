// Use transform

import 'package:drender/extensions.dart';
import 'package:drender/scene_items/modifiers/transform.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:vector_math/vector_math.dart';

import '../../process_items.dart';

class ScaleItem extends SceneItem {
  ScaleItem.vector({
    required Vector3 scale,
    required SceneItem child,
}) : _scale = scale.clone(),
  _child = child;

  ScaleItem.constant({
    required double scale,
    required SceneItem child,
}) : _scale = Vector3.all(scale),
  _child = child;

  final SceneItem _child;
  final Vector3 _scale;

  @override
  List<ProcessItem> compile() {
    return TransformItem.fromSRT(
      scale: _scale,
      child: _child,
    ).compile();
  }
}