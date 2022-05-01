import 'package:bezier/bezier.dart';
import 'package:flame/components.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:track_tool/data/spline_point.dart';
import 'package:track_tool/util/vector_conversion.dart';

class SplineSegmentComponent extends PolygonComponent {
  late List<SplinePoint> controlPoints;
  double thickness;

  final List<Vector2> _points = [];

  SplineSegmentComponent(this.controlPoints, {this.thickness = 5.0})
      : assert(controlPoints.length == 2),
        super(_calculateSplinePoints(_assignPoints(controlPoints), thickness),
            paint: Paint()..color = const Color(0xffe5c069));

  void refreshPoints() {
    if (!isLoaded) return;

    refreshVertices(
        newVertices:
            _calculateSplinePoints(_assignPoints(controlPoints), thickness));
  }

  static List<Vector2> _assignPoints(List<SplinePoint> controlPoints) {
    return [
      controlPoints.first.point,
      (controlPoints.first.handles?.last ?? Vector2.zero()) +
          controlPoints.first.point,
      (controlPoints.last.handles?.first ?? Vector2.zero()) +
          controlPoints.last.point,
      controlPoints.last.point
    ];
  }

  static List<Vector2> _calculateSplinePoints(
      List<Vector2> controlPoints, double thickness) {
    // Step 1: Create the spline
    final CubicBezier bezier =
        CubicBezier(controlPoints.map((e) => e.convert()).toList());

    // Step 2: Build evenly-spaced list, alongside normals
    final List<double> spacedPoints =
        EvenSpacer.fromBezier(bezier).evenTValues(parametersCount: 20);
    final firstOrderDerivCache = bezier.derivativePoints();
    final List<Vector2> normals = spacedPoints
        .map((e) => bezier
            .normalAt(e, cachedFirstOrderDerivativePoints: firstOrderDerivCache)
            .convert())
        .toList();

    // Step 3: Calculate left/right points
    final List<Vector2> leftPoints = [], rightPoints = [];

    for (int i = 0; i < spacedPoints.length; i++) {
      // Get the value at that given point
      double t = spacedPoints[i];
      Vector2 pointOffset = bezier.offsetPointAt(t, thickness).convert();
      Vector2 pointOtherOffset = bezier.offsetPointAt(t, -thickness).convert();
      // Create the left/right values
      leftPoints.add(pointOffset);
      rightPoints.add(pointOtherOffset);
    }

    // Step 4: Assemble into final list - add in clockwise order
    final List<Vector2> finalPoints = [];
    finalPoints.addAll(leftPoints);
    finalPoints.addAll(rightPoints.reversed);

    return finalPoints;
  }
}
