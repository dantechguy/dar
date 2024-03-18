import 'package:drender/scene.dart';
import 'package:drender/scene_items/scene_item.dart';

import '../../key.dart';
import '../../process_items.dart';

/// A collection of scene items used for organisation. Has no impact on rendering.
///
/// When compiled, these groups are removed and the tree is flattened.
class DRenderGroup extends SceneItem {
  DRenderGroup({
    required this.children,
  });

  final List<SceneItem> children;

  @override
  List<ProcessItem> compile() {
    return children
        .map((e) => e.compile())
        .fold([], (cum, cur) => cum + cur);
  }
}