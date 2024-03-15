import 'package:drender/camera.dart';
import 'package:drender/extensions.dart';
import 'package:drender/process_items.dart';
import 'package:drender/render_items.dart';
import 'package:drender/scene.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class DrenPainter extends CustomPainter {
  const DrenPainter({
    required this.camera,
    required this.scene,
  });

  final DrenCamera camera;
  final DrenScene scene;

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawCircle(
    //   Offset(size.width / 2, size.height / 2),
    //   50,
    //   Paint()
    //     ..color = Colors.red,
    // );

    canvas.translate(size.width/2, size.height/2);
    canvas.clipRect(Rect.fromCenter(center: Offset.zero, width: size.width, height: size.height));

    // final path = Path();
    // canvas.drawLine(Offset(0, 100), Offset(0, -100), Paint()..color = Colors.blue..style = PaintingStyle.stroke..strokeWidth = 2.0);

    print('render');
    final List<RenderItem> renderItems = scene.items
        .map((item) => item.compile())
        .flatten()
        .map((pItem) => pItem.optimise(camera))
        .flatten()
        .map((pItem) => pItem.compile(camera))
        .flatten()
        .toList();
    print('rendered ${renderItems.length} items');
    for (final r in renderItems) {
      r.render(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
    throw UnimplementedError();
  }
}
