import 'package:drender/extensions.dart';
import 'package:drender/sorting/sort_tri_tri.dart';

import '../camera.dart';
import '../process_items.dart';

enum SortResult {
  AInfrontofB(),
  ABehindB(),
  None();

  const SortResult();

  SortResult opposite() {
    if (this == SortResult.AInfrontofB) return SortResult.ABehindB;
    if (this == SortResult.ABehindB) return SortResult.AInfrontofB;
    return this;
  }
}

SortResult compareDrenderTree(
  ProcessItem a,
  ProcessItem b,
  DrenCamera camera,
) {
  return switch (a) {
    TriProcessItem() => switch (b) {
        TriProcessItem() => _sortTriTri(a, b, camera),
        LayerProcessItem() => _sortTriGroup(a, b, camera),
      },
    LayerProcessItem() => switch (b) {
        TriProcessItem() => _sortGroupTri(a, b, camera),
        LayerProcessItem() => _sortGroupGroup(a, b, camera),
      }
  };
}

SortResult _sortTriTri(
  TriProcessItem a,
  TriProcessItem b,
  DrenCamera camera,
) {
  // 1. First do crude 2D overlap check. If they do overlap, then do
  //    complex checking.
  final [aTri2D] = a.compile(camera);
  final [bTri2D] = b.compile(camera);
  if (!aTri2D.vertices
      .computeBoundingBox()
      .overlaps(bTri2D.vertices.computeBoundingBox())) return SortResult.None;

  // 2. Do one of five complete checks.
  if (a.vertices.isParallelWith(b.vertices)) {
    return sortTriTriParallel(a, b, camera);
  }

  final aOnLine = !b.vertices.plane.allOnSameSideOfPlane(a.vertices.toList);
  final bOnLine = !a.vertices.plane.allOnSameSideOfPlane(b.vertices.toList);

  if (!aOnLine && !bOnLine)
    return sortTriTriNeitherInIntersectionLine(a, b, camera);
  if (aOnLine && !bOnLine)
    return sortTriTriFirstOnIntersectionLine(a, b, camera);
  if (!aOnLine && bOnLine)
    return sortTriTriSecondOnIntersectionLine(a, b, camera);
  return sortTriTriBothOnIntersectionLine(a, b, camera);
}

SortResult _sortTriGroup(
    TriProcessItem a, LayerProcessItem b, DrenCamera camera) {
  // Just check if group midpoint is infront / behind tri plane.
  if (b.midpoint.behind(a.vertices.plane)) return SortResult.AInfrontofB;
  if (b.midpoint.inFrontOf(a.vertices.plane)) return SortResult.ABehindB;
  return SortResult.None;
}

SortResult _sortGroupTri(
    LayerProcessItem a, TriProcessItem b, DrenCamera camera) {
  return _sortTriGroup(b, a, camera).opposite();
}

SortResult _sortGroupGroup(
    LayerProcessItem a, LayerProcessItem b, DrenCamera camera) {
  // Midpoint to midpoint check? 😬
  return a.midpoint.distanceTo(camera.position) >
          b.midpoint.distanceTo(camera.position)
      ? SortResult.AInfrontofB
      : SortResult.ABehindB;
}
