import 'dart:ui';

import 'package:drender/key.dart';
import 'package:drender/scene_items/scene_item.dart';
import 'package:vector_math/vector_math.dart';

import '../../process_items.dart';

class TriItem extends SceneItem {
  TriItem({
    required Color colour,
    required(Vector3, Vector3, Vector3) vertices
  })
      : _colour = colour,
        _vertices = vertices;

  final Color _colour;
  final (Vector3, Vector3, Vector3) _vertices;

  @override
  List<ProcessItem> compile() {
    return [TriProcessItem(vertices: _vertices, colour: _colour)];
  }
}