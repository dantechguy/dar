import 'dart:ui';
import 'package:drender/camera.dart';
import 'package:vector_math/vector_math.dart';

Offset project3DTo2D(Vector3 point, DrenCamera camera) {
  point -= camera.position;
  camera.rotation.inverted().rotate(point);

  // A quaternion is just a rotation, so the zero-direction is defined
  // by where you look after the transformation. We assume at position
  // (0, 0, 0), facing +X, with +Z above us, and +Y to our left.
  //
  // This is a +Z up, right-handed coordinate system.

  /* TODO:
      - incorporate FOV
      - the quaternion representing the camera isn't being used properly.
        it should represent the direction the camera is facing, and a rotation.
        but atm it represents a rotation from the +X facing direction.
  */

  // Top-down othographic projection
  // return Offset(point.x * 10, point.y * 10);

  return Offset(point.y/point.x/camera.fov, point.z/point.x/camera.fov);
}