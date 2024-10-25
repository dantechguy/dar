import 'package:ren/src/painter.dart';
import 'package:ren/src/scene.dart';
import 'package:flutter/material.dart';
import 'package:ren/ren.dart';


// TODO: Rename to something 'canvas'?
class RenView extends StatelessWidget {
  const RenView({
    required this.camera,
    required this.items,
    this.backgroundColor = Colors.black,
    super.key,
  });

  final CameraD camera;
  final List<SceneItem> items;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: RenPainter(
          camera: camera,
          items: items,
          backgroundColor: backgroundColor,
        ),
      ),
    );
  }
}
