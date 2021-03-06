import 'package:flame/components.dart';
import 'package:track_tool/data/spline_point.dart';

class Spline {
  List<SplinePoint> points;

  Spline() : points = [];
  Spline.fromPoints(this.points);

  void addPoint(SplinePoint point) {
    // Take the new point, add it to the end of the list
    points.add(point);
  }

  void updatePointPosition(int index, Vector2 newPosition) {
    points[index].point = newPosition;
  }

  // TODO: Serialization
  // TODO: Deserialization
}
