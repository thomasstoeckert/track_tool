import 'package:flame/components.dart';

class SplinePoint {
  Vector2 point;
  List<Vector2>? handles;

  ///
  /// Create a spline point with a given point and some handles
  ///
  SplinePoint(this.point, {this.handles}) : assert((handles?.length ?? 2) == 2);

  ///
  /// Create a spline point with a given point and create handles at distance
  ///
  SplinePoint.withHandles(this.point, {double handleScale = 5.0})
      : handles = [Vector2(-1 * handleScale, 0), Vector2(1 * handleScale, 0)];

  @override
  String toString() {
    return point.toString();
  }

  // TODO: Deserialization/serialization
}
