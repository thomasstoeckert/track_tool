import 'dart:ffi';

import 'package:flame/components.dart';

class SplinePoint {
  Vector2 point;
  List<Vector2>? handles;

  SplinePoint(this.point, {this.handles});

  // TODO: Deserialization/serialization
}
