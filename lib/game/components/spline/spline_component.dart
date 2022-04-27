import 'package:flame/components.dart';
import 'package:track_tool/data/spline.dart';
import 'package:track_tool/data/spline_point.dart';
import 'package:track_tool/game/components/spline/spline_point_component.dart';
import 'package:track_tool/game/components/spline/spline_segment_component.dart';

class SplineComponent extends PositionComponent {
  final Spline spline;

  SplineComponent(position, this.spline) : super(position: position);

  final List<SplinePointComponent> childPoints = [];
  final List<SplineSegmentComponent> childSegments = [];

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Go through and create our spline children points and segments
    // Handles are easy - just grab the points and throw them into spline point components
    for (SplinePoint point in spline.points) {
      childPoints.add(SplinePointComponent(point, showHandles: true));
    }

    // Segments are harder - we have to build a spline using the leading & trailing handles and their leading & trailing points
    for (int i = 1; i < spline.points.length; i++) {
      // Select the four points that are important for this
      List<Vector2> selectedPoints = [];

      selectedPoints.add(spline.points[i - 1].point);
      selectedPoints
          .add(spline.points[i - 1].handles?.last ?? spline.points[1].point);
      selectedPoints
          .add(spline.points[i].handles?.first ?? spline.points[0].point);
      selectedPoints.add(spline.points[i].point);

      // Create our segment
      childSegments.add(SplineSegmentComponent(selectedPoints));
    }

    addAll([...childSegments, ...childPoints]);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Increase / decrease the amount of children we have, if we need to.
    int neededPoints = spline.points.length;
    bool madeChange = false;
    if (childPoints.length != neededPoints) {
      // If the number of children we have is below the number of points we need...
      if (childPoints.length < neededPoints) {
        // Add some segments
        int numPointsNeeded = neededPoints - childPoints.length;
        int numSegmentsNeeded = (childPoints.length >= 2) ? numPointsNeeded : 0;
        for (int i = 0; i < numSegmentsNeeded; i++) {
          childSegments.add(SplineSegmentComponent([
            Vector2.zero(),
            Vector2.zero(),
            Vector2.zero(),
            Vector2.zero()
          ]));
          add(childSegments.last);
        }

        // Add some children
        for (int i = 0; i < numPointsNeeded; i++) {
          childPoints.add(SplinePointComponent(SplinePoint(Vector2(0, 0))));
          add(childPoints.last);
        }
        madeChange = true;
      } else if (childPoints.length > neededPoints) {
        madeChange = true;
        // Remove some children
        int numPointsToRemove = childPoints.length - neededPoints;
        int numSegmentsToRemove = numPointsToRemove - 1;

        // Remove points
        for (int i = 0; i < numPointsToRemove; i++) {
          remove(childPoints[i]);
        }

        // Remove segments
        for (int i = 0; i < numSegmentsToRemove; i++) {
          remove(childSegments[i]);
        }
      }
    }

    // Update the data assignments for the children
    if (madeChange) {
      // Go through and update our spline children points and segments
      // Handles are easy - just grab the points and throw them into spline point components
      for (int i = 0; i < spline.points.length; i++) {
        childPoints[i].point = spline.points[i];
      }

      // Segments are harder - we have to build a spline using the leading & trailing handles and their leading & trailing points
      for (int i = 1; i < spline.points.length; i++) {
        // Select the four points that are important for this
        List<Vector2> selectedPoints = [];

        selectedPoints.add(spline.points[i - 1].point);
        selectedPoints
            .add(spline.points[i - 1].handles?.last ?? spline.points[1].point);
        selectedPoints
            .add(spline.points[i].handles?.first ?? spline.points[0].point);
        selectedPoints.add(spline.points[i].point);

        // Create our segment
        childSegments[i - 1].points = selectedPoints;
        childSegments[i - 1].refreshPoints();
      }
    }
  }
}
