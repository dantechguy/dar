import 'package:drender/scene_items/groups/group.dart';

import '../../process_items.dart';
import '../scene_item.dart';
import 'invert.dart';

/// Flips the direction of all tris (reverses normal)
class DoubleSideItem extends SceneItem {
  DoubleSideItem({
    required SceneItem child,
  }) : _child = child;

  final SceneItem _child;

  @override
  List<ProcessItem> compile() {
    return DRenderGroup(children: [
      _child,
      InvertItem(child: _child),
    ]).compile();
  }
}
