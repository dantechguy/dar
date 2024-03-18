import 'dart:async';
import 'dart:math' as math;

import 'package:drender/camera.dart';
import 'package:drender/scene_items/groups/group.dart';
import 'package:drender/scene_items/modifiers/invert.dart';
import 'package:drender/scene_items/modifiers/rotate.dart';
import 'package:drender/scene_items/modifiers/shade.dart';
import 'package:drender/tempexample.dart';
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
  double xCoord = 0;
  double yCoord = 0;
  double zCoord = 0;
  int renderAmountCounter = 0;
  double objectRotation = 0;

  @override
  void initState() {
    super.initState();

    Timer.periodic(
        Duration(milliseconds: 10),
        (timer) => setState(() {
              renderAmountCounter++;
              objectRotation += 0.01;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          if (details.globalPosition.dx <
              MediaQuery.of(context).size.width / 5) {
            zCoord += -details.delta.dy / 10;
          } else if (details.globalPosition.dx <
              MediaQuery.of(context).size.width / 2) {
            xCoord += (-math.cos(hRot) * details.delta.dy / 10) +
                (math.sin(hRot) * details.delta.dx / 10);
            yCoord += (math.sin(hRot) * details.delta.dy / 10) +
                (math.cos(hRot) * details.delta.dx / 10);
          } else {
            hRot += -details.delta.dx / 100;
            vRot += -details.delta.dy / 100;
          }
        });
      },
      child: ViewDAR(
        // counter: renderAmountCounter,
        // camera: CameraD.fromPositiveX(
        //   fov: 0.005,
        //   position: Vector3(xCoord, yCoord, 0),
        //   rotation: Quaternion.axisAngle(CAxis.positiveZ.unitVector, hRot),
        // ),
        camera: CameraD.fromYawPitchRoll(
          fov: 200,
          position: Vector3(xCoord, yCoord, zCoord),
          // TODO: why is this not what i expect?
          yawPitchRoll: Vector3(vRot, 0, hRot),
        ),
        items: [
          ShadeItem(
            ambientLight: Colors.white.withOpacity(.2),
            directionalLights: [
              (Vector3(-.5, 1, -2), Colors.yellow.withOpacity(0.2)),
              (Vector3(1, -2, -2), Colors.red.withOpacity(0.01)),
            ],
            child: RotateItem.aroundAxis(
                axis: CAxis.up(),
                rotation: objectRotation,
                child: InvertItem(
                  child: DRenderGroup(
                    children: mesh,
                  ),
                )),
          ),
        ],
      ),
    ));
  }
}
