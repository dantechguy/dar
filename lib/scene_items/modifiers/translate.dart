
// Use transform

import 'package:drender/extensions.dart';
import 'package:drender/scene_items/modifiers/transform.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:vector_math/vector_math.dart';

import '../../process_items.dart';

class TranslateItem extends SceneItem {
  TranslateItem.fromVector({
    required Vector3 translate,
    required SceneItem child,
  }) : _translation = translate.clone(),
        _child = child;

  final SceneItem _child;
  final Vector3 _translation;

  @override
  List<ProcessItem> compile() {
    return TransformItem.fromSRT(
      translate: _translation,
      child: _child,
    ).compile();
  }
}
