import 'package:flame/components.dart';
import 'package:bezier/bezier.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:track_tool/util/vector_conversion.dart';

class CurvyLineSegment extends PolygonComponent {
  final List<Vector2> points;
  late Vector2 firstPointOffset;

  CurvyLineSegment(this.points)
      : super(calculateCurve(points),
            //position: points.first,
            paint: Paint()..color = const Color(0xff00ffff));

  static List<Vector2> calculateCurve(List<Vector2> points) {
    // Step 1: Create our quadratic bezier curve
    final curve = QuadraticBezier(points.map((p) => p.convert()).toList());

    const numSteps = 10;

    // Create an offset curve on the left side
    final leftCurves = curve.offsetCurve(-10.0);
    // Create an offset curve on the right side
    final rightCurves = curve.offsetCurve(10.0);

    // Create points for left and right
    final List<Vector2> leftPoints = [];
    final List<Vector2> rightPoints = [];

    for (final curve in leftCurves) {
      final List<double> spacingVals =
          EvenSpacer.fromBezier(curve).evenTValues(parametersCount: numSteps);
      for (final t in spacingVals) {
        leftPoints.add(curve.pointAt(t).convert());
      }
    }

    for (final curve in rightCurves) {
      final List<double> spacingVals =
          EvenSpacer.fromBezier(curve).evenTValues(parametersCount: numSteps);
      for (final t in spacingVals) {
        rightPoints.add(curve.pointAt(t).convert());
      }
    }

    // Build our final set of points - left sequentially, right in reverse order
    final List<Vector2> finalPoints = [];
    finalPoints.addAll(leftPoints);
    finalPoints.addAll(rightPoints.reversed);

    return finalPoints;
  }
}
