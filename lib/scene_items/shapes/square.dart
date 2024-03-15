import 'dart:math';
import 'dart:ui';

import 'package:drender/key.dart';
import 'package:drender/scene_items/shapes/regular_polygon.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:vector_math/vector_math.dart';

import '../../process_items.dart';


class SquareItem extends SceneItem {
  SquareItem({
    required Color colour,
    required double sideLength,
  }) : _colour = colour,
        _sideLength = sideLength;

  final Color _colour;
  final double _sideLength;

  @override
  List<ProcessItem> compile() {
    return RegularPolygonItem.fromSideLength(
      sideLength: _sideLength,
      colour: _colour,
      n: 4,
    ).compile();
  }
}
