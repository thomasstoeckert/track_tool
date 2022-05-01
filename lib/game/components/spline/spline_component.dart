import 'package:flame/components.dart';
import 'package:flame/layers.dart';
import 'package:track_tool/data/spline.dart';
import 'package:track_tool/game/components/spline/spline_point_component.dart';
import 'package:track_tool/game/components/spline/spline_segment_component.dart';

class SplineComponent extends PositionComponent {
  final Spline spline;

  SplineComponent(position, this.spline) : super(position: position);

  final List<SplinePointComponent> childPoints = [];
  final List<SplineSegmentComponent> childSegments = [];
  List<int>? selectedPoints;
  List<int>? selectedSegment;

  // What if... doubly-linked list?
  // Us (SplineComponent) creates a base point (required for a spline)
  // Point Added:
  //  - Create new point at new position
  //  - Create segment, trailing to the last position
  // Point Removed:
  //  - Delete point
  //  - Split / delete spline as required
  // Point Updated:
  //  - Store change of point
  //  - Update neighboring segments

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Get our first point, which is required for a spline component
    childPoints.add(SplinePointComponent(spline.points.first));

    // Go through and create our spline children points and segments
    // Handles are easy - just grab the points and throw them into spline point components
    for (int i = 1; i < spline.points.length; i++) {
      // Create the new segment
      SplineSegmentComponent newSegment =
          SplineSegmentComponent([spline.points[i - 1], spline.points[i]]);

      // Create its new point
      SplinePointComponent newPoint = SplinePointComponent(spline.points[i]);

      // Assign leading/trailing values
      SplinePointComponent lastPoint = childPoints[i - 1];
      lastPoint.trailingSegment = newSegment;
      newPoint.leadingSegment = newSegment;

      childPoints.add(newPoint);
      childSegments.add(newSegment);
    }

    print(
        "Loaded component with ${childPoints.length} points, ${childSegments.length} segments");

    // Add the segments first, then the control points
    addAll([...childSegments, ...childPoints]);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Increase / decrease the amount of children we have, if we need to.
    int neededPoints = spline.points.length;

    if (childPoints.length != neededPoints) {
      // If the number of children we have is below the number of points we need...
      if (childPoints.length < neededPoints) {
        // Add some segments & points
        int numPointsNeeded = neededPoints - childPoints.length;
        int startingPoint = childPoints.length;

        for (int i = 0; i < numPointsNeeded; i++) {
          // Create our new point + segment
          SplinePointComponent newPoint =
              SplinePointComponent(spline.points[startingPoint + i]);
          SplineSegmentComponent newSegment = SplineSegmentComponent([
            spline.points[startingPoint - 1 + i],
            spline.points[startingPoint + i]
          ]);

          // Assign our segment to our point
          newPoint.leadingSegment = newSegment;
          childPoints.last.trailingSegment = newSegment;

          childPoints.add(newPoint);
          childSegments.add(newSegment);

          // Add each
          addAll([newSegment, newPoint]);
        }
      } else if (childPoints.length > neededPoints) {
        // Remove some children
        int numPointsToRemove = childPoints.length - neededPoints;

        // Remove points & segments
        for (int i = 0; i < numPointsToRemove; i++) {
          remove(childPoints.last);
          remove(childSegments.last);
        }
      }
    }
  }
}
