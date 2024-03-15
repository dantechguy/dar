import 'dart:math';
import 'dart:ui';

import 'package:vector_math/vector_math.dart';

Plane Plane_fromNormalAndPoint(Vector3 normal, Vector3 point) {
  return Plane.components(normal.x, normal.y, normal.z, -normal.dot(point));
}

extension DPlane on Plane {
  bool allOnSameSideOfPlane(Iterable<Vector3> points, {double eps = 0}) {
    final pointsSides =
        points.map((point) => point.sideOfPlane(this, eps: eps));
    return !(pointsSides.contains(-1) && pointsSides.contains(1));
  }

  Plane planeInFrontAlongNormal(double distance) {
    final newPoint = point + normal.normalized() * distance;
    return Plane_fromNormalAndPoint(normal, newPoint);
  }

  // TODO: test
  Vector3 get point => normal.normalized() * constant / normal.length;
}

extension DVector3 on Vector3 {
  bool behind(Plane p,) => sideOfPlane(p) <= 0;

  bool inFrontOf(Plane p) =>
      sideOfPlane(p) >= 0;

  bool onPlane(Plane p, {double eps = 0}) => sideOfPlane(p, eps: eps) == 0;

  int sideOfPlane(Plane p, {double eps = 0}) {
    final d = p.distanceToVector3(this);
    return d < -eps
        ? -1
        : d > eps
            ? 1
            : 0;
  }

  Vector3 vectorToPlane(Plane p) =>
      p.normal.normalized() * -p.distanceToVector3(this);

  Vector3 flipAroundPlane(Plane p) => this + vectorToPlane(p) * 2;
}

extension DTri3D on (Vector3, Vector3, Vector3) {
  /// A tri facing you has its points positioned clockwise
  Vector3 get normal {
    Vector3 output = Vector3(0, 0, 0);
    cross3($3 - $1, $2 - $1, output);
    return output;
  }

  Plane get plane => Plane_fromNormalAndPoint(normal, $1);

  // TODO: add eps
  bool isParallelWith((Vector3, Vector3, Vector3) otherTri) =>
      normal == otherTri.normal || normal == -otherTri.normal;

  List<Vector3> get toList => [$1, $2, $3];

  List<(Vector3, Vector3)> get edgeList => [($1, $2), ($2, $3), ($3, $1)];

  (Vector3, Vector3, Vector3) scaleByVector(Vector3 s) => (
        $1.clone()..multiply(s),
        $2.clone()..multiply(s),
        $3.clone()..multiply(s),
      );

  (Vector3, Vector3, Vector3) rotateByQuaternion(Quaternion q) => (
        q.rotated($1),
        q.rotated($2),
        q.rotated($3),
      );

  (Vector3, Vector3, Vector3) translateByVector(Vector3 t) => (
        $1 + t,
        $2 + t,
        $3 + t,
      );

  (E, E, E) map<E>(E Function(Vector3 v) f) => (f($1), f($2), f($3));

  bool intersectsPlane(Plane p, {double eps = 0}) =>
      !p.allOnSameSideOfPlane(toList, eps: eps);

  (
    (Vector3, Vector3, Vector3),
    (Vector3, Vector3, Vector3)?,
    (Vector3, Vector3, Vector3)?
  ) splitOnPlane(Plane p) {
    if (intersectsPlane(p)) {
      final vertices = toList;
      while (!p.allOnSameSideOfPlane(vertices.sublist(1))) {
        vertices.rotateForward();
      }
      /* ASSERT:
          - have list [A, B, C]
          - vertices B and C are on the same side of the plane, vertex A on the other
          - the order of vertices of this tri (clockwise) is A -> B -> C
       */
      final [vertexA, vertexB, vertexC] = vertices;
      final vertexABSplit = (vertexA, vertexB).intersectPlane(p);
      final vertexCASplit = (vertexC, vertexA).intersectPlane(p);

      final tri1 = (vertexA, vertexABSplit, vertexCASplit);
      final tri2 = (vertexABSplit, vertexB, vertexC);
      final tri3 = (vertexABSplit, vertexC, vertexCASplit);
      return (tri1, tri2, tri3);
    } else {
      return (this, null, null);
    }
  }
}

extension DLine3D on (Vector3, Vector3) {
  bool intersectsPlane(Plane p) => !p.allOnSameSideOfPlane([$1, $2]);

  Vector3 get direction => ($2 - $1).normalized();

  Vector3 intersectPlane(Plane p) =>
      $1 +
      direction /
          direction.dot(p.normal.normalized()) *
          -p.distanceToVector3($1);

  ((Vector3, Vector3), (Vector3, Vector3)?) splitOnPlane(Plane p) {
    if (intersectsPlane(p)) {
      final iPoint = intersectPlane(p);
      return (($1, iPoint), (iPoint, $2));
    } else {
      return (this, null);
    }
  }
}

extension DTri2D on (Offset, Offset, Offset) {
  Rect computeBoundingBox() {
    double xMin = double.negativeInfinity;
    double yMin = double.negativeInfinity;
    double xMax = double.infinity;
    double yMax = double.infinity;
    for (final o in [$1, $2, $3]) {
      xMin = min(xMin, o.dx);
      xMax = max(xMax, o.dx);
      yMin = min(yMin, o.dy);
      yMax = max(yMax, o.dy);
    }
    return Rect.fromLTRB(xMin, yMax, xMax, yMin);
  }
}

extension DOffset on Offset {
  Offset clamp(Rect r) =>
      Offset(dx.clamp(r.left, r.right), dy.clamp(r.top, r.bottom));
}

extension DIterable<E> on Iterable<E> {
  bool allEqual() => length <= 1 || skip(1).every((e) => e == first);
}

extension DIterableIterable<E> on Iterable<Iterable<E>> {
  Iterable<E> flatten() => expand((e) => e);
}

extension DColor on Color {
  Vector4 toVector() =>
      Vector4(red / 255, green / 255, blue / 255, alpha / 255);
}

extension DVector4 on Vector4 {
  /// Returns new Vector
  Vector4 mult(Vector4 v) => clone()..multiply(v);

  Color toColor() => Color.fromARGB(
        (a * 255).clamp(0, 255).toInt(),
        (r * 255).clamp(0, 255).toInt(),
        (g * 255).clamp(0, 255).toInt(),
        (b * 255).clamp(0, 255).toInt(),
      );
}

extension DList<E> on List<E> {
  void rotateForward() => add(removeAt(0));
}
