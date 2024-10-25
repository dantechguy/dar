import 'package:ren/ren.dart';
import 'package:ren/src/extensions.dart';

import '../../process_items.dart';

/// A collection of scene items used for organisation. Has no impact on rendering.
///
/// When compiled, these groups are removed and the tree is flattened.
class RenGroup extends SceneItem {
  RenGroup({
    required this.children,
  });

  final List<SceneItem> children;

  @override
  List<ProcessItem> compile() {
    return children
        .map((e) => e.compile())
        .flatten()
        .toList();
  }
}