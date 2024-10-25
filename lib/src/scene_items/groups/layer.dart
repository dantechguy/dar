import 'package:ren/ren.dart';
import 'package:ren/src/extensions.dart';

import '../../process_items.dart';


/// A collection of scene items which are rendered in the same layer.
///
/// Has the visual appearance of rendering this layer separately, and then
/// compositing it into the scene afterwards. It means that no other scene items
/// can appear 'inside' this scene item, only wholly in front or behind.
class RenLayer extends SceneItem {
  RenLayer({
    required this.children,
  });

  final List<SceneItem> children;

  @override
  List<ProcessItem> compile() {
    return [
      GroupProcessItem(
        children: children
            .map((child) => child.compile())
            .flatten()
            .toList(),
      )
    ];
  }
}
