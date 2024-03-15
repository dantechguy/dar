import 'dart:ui';
import 'dart:math' as math;
import 'package:drender/extensions.dart';

sealed class RenderItem {
  void render(Canvas canvas, Size size);
}

class RenderTri extends RenderItem {
  RenderTri({
    required this.vertices,
    required this.colour,
  });

  final Color colour;
  final (Offset, Offset, Offset) vertices;

  @override
  void render(Canvas canvas, Size size) {

    // TODO: fix until https://github.com/flutter/flutter/issues/145229 fixed
    // Rect bound = Rect.fromCenter(center: Offset.zero, width: 1000, height: 1000);
    // final tris = [vertices.$1, vertices.$2, vertices.$3].map((tri) => tri.clamp(bound)).toList();
    final tris = [vertices.$1, vertices.$2, vertices.$3];

    canvas.drawVertices(
      Vertices(
        VertexMode.triangles,
        tris,
      ),
      BlendMode.src,
      Paint()..color = colour,
    );

    // print('trirender $tris');
    // final randomColour = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    //
    // canvas.save();
    // final random = math.Random();
    // final dx = random.nextDouble() * 4 - 2;
    // final dy = random.nextDouble() * 4 - 2;
    // canvas.translate(dx, dy);
    //
    // final path = Path();
    // path.moveTo(vertices.$1.dx, vertices.$1.dy);
    // path.lineTo(vertices.$2.dx, vertices.$2.dy);
    // path.lineTo(vertices.$3.dx, vertices.$3.dy);
    // path.close();
    // final paint = Paint()..color = randomColour
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1.0;
    // canvas.drawPath(path, paint);
    //
    // canvas.restore();
  }
}
