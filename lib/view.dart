import 'package:drender/camera.dart';
import 'package:drender/painter.dart';
import 'package:drender/scene.dart';
import 'package:flutter/material.dart';

class DrenView extends StatelessWidget {
  const DrenView({
    required this.camera,
    required this.scene,
    super.key,
  });

  final DrenCamera camera;
  final DrenScene scene;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: DrenPainter(
          camera: camera,
          scene: scene,
        ),
      ),
    );
  }
}
