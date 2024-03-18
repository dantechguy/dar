import 'package:drender/camera.dart';
import 'package:drender/painter.dart';
import 'package:drender/scene.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:flutter/material.dart';

// TODO: Rename to something 'canvas'?
class ViewDAR extends StatelessWidget {
  const ViewDAR({
    required this.camera,
    required this.items,
    this.counter,
    super.key,
  });

  final CameraD camera;
  final List<SceneItem> items;
  final int? counter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
        painter: DrenPainter(
          counter: counter,
          camera: camera,
          items: items,
        ),
      ),
    );
  }
}
