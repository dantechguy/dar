import 'dart:math';

import 'package:drender/extensions.dart';
import 'package:vector_math/vector_math.dart';

class DrenCamera {
  DrenCamera.fromPositiveX({
    required this.position,
    required this.rotation,
    this.fov = 1,
  });

  DrenCamera.lookingAt({
    required Vector3 position,
    required Vector3 lookPoint,
    double tilt = 0,
    double fov = 1,
  }) : this.direction(
          position: position,
          direction: lookPoint - position,
          tilt: tilt,
          fov: fov,
        );

  DrenCamera.direction({
    required this.position,
    required Vector3 direction,
    double tilt = 0,
    this.fov = 1,
  }) {
    // https://stackoverflow.com/a/1171995/9063935
    final Vector3 forward = Vector3(1, 0, 0);

    if (forward.dot(direction) < -0.99999) {
      rotation = Quaternion.axisAngle(Vector3(0, 0, 1), pi);
    } else if (forward.dot(direction) > 0.99999) {
      rotation = Quaternion.axisAngle(Vector3(0, 0, 1), 0);
    } else {
      final Vector3 xyz = forward.cross(direction);
      final double w =
          sqrt(forward.length2 * direction.length2) + forward.dot(direction);
      rotation = Quaternion(xyz.x, xyz.y, xyz.z, w);
    }
  }

  final Vector3 position;

  late final Quaternion rotation;

  /// Scales input screen size. A larger number increases the FOV.
  final double fov;

  // There is no aspect ratio, as this is given in the CustomPainter.paint callback.

  Vector3 get dir => rotation.rotated(Vector3(1, 0, 0));

  Plane get plane => Plane_fromNormalAndPoint(dir, position);
}
