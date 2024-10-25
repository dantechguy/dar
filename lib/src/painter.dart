import 'package:ren/ren.dart';
import 'package:ren/src/extensions.dart';
import 'package:ren/src/process_items.dart';

import 'package:ren/src/render_items.dart';
import 'package:ren/src/scene.dart';
import 'package:flutter/material.dart';

class RenPainter extends CustomPainter {
  const RenPainter({
    required this.camera,
    required this.items,
    required this.backgroundColor,
  });

  final CameraD camera;
  final List<SceneItem> items;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawCircle(
    //   Offset(size.width / 2, size.height / 2),
    //   50,
    //   Paint()
    //     ..color = Colors.red,
    // );
    canvas.drawColor(Colors.black, BlendMode.src);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.clipRect(Rect.fromCenter(
        center: Offset.zero, width: size.width, height: size.height));

    // final path = Path();
    // canvas.drawLine(Offset(-size.width/2, 0), Offset(size.width/2, 0), Paint()..color = Colors.blue..style = PaintingStyle.stroke..strokeWidth = 1.0);

    // print('render');
    final List<RenderItem> renderItems = GroupProcessItem(
            children: items
                .map((item) => item.compile())
                .flatten()
                .map((pItem) => pItem.process(camera))
                .flatten()
                .toList())
        .sort(null, camera)
        .compile(camera)
        .toList();
    // print('rendered ${renderItems.length} items');
    // print(count);
    for (final r in renderItems) {
      canvas.save();
      r.render(canvas, size);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
    throw UnimplementedError();
  }
}
