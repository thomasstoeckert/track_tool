import 'package:bezier/bezier.dart';
import 'package:flame/components.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:track_tool/util/vector_conversion.dart';

class SplineSegmentComponent extends PositionComponent {
  List<Vector2> points;
  double thickness;

  SplineSegmentComponent(this.points, {this.thickness = 5.0});

  late PolygonComponent segmentRenderer;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Create our child, the spline segment renderer
    List<Vector2> polyPoints = calculateSplinePoints(points, thickness);
    segmentRenderer = PolygonComponent(polyPoints,
        paint: Paint()..color = const Color(0xffe5c069));

    add(segmentRenderer);
  }

  void refreshPoints() {
    if (!isLoaded) return;

    List<Vector2> polyPoints = calculateSplinePoints(points, thickness);
    remove(segmentRenderer);
    segmentRenderer = PolygonComponent(polyPoints,
        paint: Paint()..color = const Color(0xffe5c069));
    add(segmentRenderer);
  }

  static List<Vector2> calculateSplinePoints(
      List<Vector2> controlPoints, double thickness) {
    // Step 1: Create the spline
    final CubicBezier bezier =
        CubicBezier(controlPoints.map((e) => e.convert()).toList());

    // Step 2: Build a list of evenly-spaced Ts along the segment, with tangents
    final EvenSpacer spacer = EvenSpacer.fromBezier(bezier);
    final List<double> evenTs = spacer.evenTValues(parametersCount: 9);

    // -- Calculate derivative stuff once for efficiency
    final pointsCache = bezier.derivativePoints();
    final List<Vector2> normals = evenTs
        .map((e) => bezier
            .normalAt(e, cachedFirstOrderDerivativePoints: pointsCache)
            .convert())
        .toList();

    // Step 3: Calculate left/right points
    final List<Vector2> leftPoints = [], rightPoints = [];
    for (int i = 0; i < evenTs.length; i++) {
      double tValue = evenTs[i];
      Vector2 normal = normals[i];

      // Get the point information at that... point
      Vector2 pointData = bezier.pointAt(tValue).convert();

      // Calculate the points by adding / subtracting the scaled normals
      // to the point data
      leftPoints.add(pointData + normal.scaled(thickness));
      rightPoints.add(pointData - normal.scaled(thickness));
    }

    // Step 4: Assemble into final list - add in clockwise order
    final List<Vector2> finalPoints = [];
    finalPoints.addAll(leftPoints);
    finalPoints.addAll(rightPoints.reversed);

    return finalPoints;
  }
}
