import 'dart:math' as math;

import 'package:ren/ren.dart';
import 'package:ren/src/tempexample.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

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

    // Timer.periodic(
    //     Duration(milliseconds: 10),
    //     (timer) => setState(() {
    //           renderAmountCounter++;
    //           objectRotation += 0.01;
    //         }));
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
            fov: 400,
            position: Vector3(xCoord, yCoord, zCoord),
            // TODO: why is this not what i expect?
            yawPitchRoll: Vector3(vRot, 0, hRot),
          ),
          items: [
            ShadeItem(
              ambientLight: Colors.white.withOpacity(0.2),
              directionalLights: [
                (Vector3(1, 1, -1), Colors.white),
                // (Vector3(-1, 0, 0), Colors.blue),
              ],
              child: InvertItem(child: DRenderGroup(
                children: mesh,
              ))
            ),
          ]
          // items: [
          //   ShadeItem(
          //     ambientLight: Colors.white.withOpacity(0.2),
          //     directionalLights: [
          //       (Vector3(1, 1, -1), Colors.white),
          //       // (Vector3(-1, 0, 0), Colors.blue),
          //     ],
          //     child: DRenderGroup(
          //       children: [
          //         InvertItem(
          //             child: TransformItem.fromSRT(
          //           rotate: Quaternion.axisAngle(Vector3(1, 0, 0), 0.4),
          //           child: RegularPrismItem.fromRadiusHeight(
          //             colour: Colors.red,
          //             n: 3,
          //             height: 4,
          //             radius: 2,
          //           ),
          //         )),
          //         TransformItem.fromSRT(
          //           translate: Vector3(0, 0, -4),
          //           child: SquareItem(
          //             colour: Colors.green,
          //             sideLength: 15,
          //           ),
          //         ),
          //         TransformItem.fromSRT(
          //           translate: Vector3(0, 4, 4),
          //           rotate: Quaternion.axisAngle(Vector3(1, 1, 0), 0.3),
          //           child: CuboidItem.fromLengths(
          //             x: 3,
          //             y: 1,
          //             z: 2,
          //             colour: Colors.blue,
          //           ),
          //         ),
          //         TransformItem.fromSRT(
          //           rotate: Quaternion.axisAngle(Vector3(-0.3,1 ,0 ), 1.6),
          //           translate: Vector3(-4, -4, 4),
          //           child: InvertItem(
          //             child: RegularPrismItem.fromRadiusHeight(
          //               height: 10,
          //               radius: 0.5,
          //               colour: Colors.orange,
          //               n: 100,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   )
          // ],
          ),
    ));
  }
}
