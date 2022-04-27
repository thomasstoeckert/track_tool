import 'dart:ffi';

import 'package:flame/components.dart';

class SplinePoint {
  Vector2 point;
  List<Vector2>? handles;

  ///
  /// Create a spline point with a given point and some handles
  ///
  SplinePoint(this.point, {this.handles});

  ///
  /// Create a spline point with a given point and create handles at distance
  ///
  SplinePoint.withHandles(this.point, {double handleScale = 5.0})
      : handles = [
          point + Vector2(-1 * handleScale, 0),
          point + Vector2(1 * handleScale, 0)
        ] {
    print(
        "New point: $point, left handle: ${handles![0]}, right handle: ${handles![1]}");
  }

  // TODO: Deserialization/serialization
}
