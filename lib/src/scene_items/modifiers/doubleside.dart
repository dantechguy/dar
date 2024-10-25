import 'package:ren/ren.dart';

import '../../process_items.dart';

/// Flips the direction of all tris (reverses normal)
class DoubleSideItem extends SceneItem {
  DoubleSideItem({
    required SceneItem child,
  }) : _child = child;

  final SceneItem _child;

  @override
  List<ProcessItem> compile() {
    return RenGroup(children: [
      _child,
      InvertItem(child: _child),
    ]).compile();
  }
}
