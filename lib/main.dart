import 'package:drender/camera.dart';
import 'package:drender/scene.dart';
import 'package:drender/scene_items/modifiers/rotate.dart';
import 'package:drender/scene_items/modifiers/transform.dart';
import 'package:drender/scene_items/shapes/cube.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

import 'view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'drender',
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double hRot = 0;
  double vRot = 0;

  @override
  void initState() {
    super.initState();

    //   final camera = DrenCamera.fromPositiveX(
    //       position: Vector3(0, 0, 0),
    //       rotation: Quaternion.axisAngle(Vector3(0, 0, 1), hRot));
    //
    //   item = TransformItem.fromScaleRotateTranslate(
    //     rotate: Quaternion.axisAngle(CartesianAxis.positiveY.unitVector, -pi / 2),
    //     translate: Vector3(5, 0, 0),
    //     child: SquareItem(
    //       sideLength: 5,
    //       colour: Colors.red,
    //     ),
    //   );
    //   final processItems = item.compile();
    //   for (final pi in processItems)
    //     print('process item: ${pi is TriProcessItem ? pi.vertices : ''}');
    //   final renderItems =
    //   processItems.map((e) => e.compile(camera)).flatten().toList();
    //   for (final ril in renderItems)
    //     print('render item: ${ril is RenderTri ? ril.vertices : ''}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          hRot += details.delta.dx / 100;
          vRot += details.delta.dy / 100;
        });
      },
      child: DrenView(
        camera: DrenCamera.fromPositiveX(
            fov: 0.005,
            position: Vector3(0, 0, 0),
            rotation: Quaternion.axisAngle(Vector3(0, 0, 1), 0)),
        scene: DrenScene(items: [
          TransformItem.fromSRT(
            rotate:
                Quaternion.axisAngle(CartesianAxis.positiveZ.unitVector, hRot),
            translate: Vector3(2, 0, 0),
            child: RotateItem.aroundAxis(
              axis: CartesianAxis.positiveY,
              rotation: vRot,
              child: CubeItem.fromSize(
                size: 2.31,
                colour: Colors.red,
              ),
            ),
          ),
          // item,
        ]),
      ),
    ));
  }
}
