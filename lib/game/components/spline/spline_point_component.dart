import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/components.dart' as drag_override;
import 'package:flame/input.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:track_tool/data/spline_point.dart';
import 'package:track_tool/game/components/line_segment.dart';
import 'package:track_tool/game/components/spline/spline_segment_component.dart';
import 'package:track_tool/game/renderer.dart';

class SplinePointComponent extends PositionComponent
    with
        drag_override.Draggable,
        GestureHitboxes,
        /* Hoverable */
        HasGameRef<RideEditorViewport> {
  bool showHandles;
  SplinePoint point;

  SplinePointComponent(this.point, {this.showHandles = false});

  late RectangleComponent? handle1, handle2;
  late LineSegment? handleBar1, handleBar2;
  late CircleComponent pointMarker;

  // The segment leading from some other point to this point
  SplineSegmentComponent? trailingSegment;

  // The segment leading from this point to another point
  SplineSegmentComponent? leadingSegment;

  Vector2? dragDeltaPosition;
  bool get isDragging => dragDeltaPosition != null;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Set our point position
    position = point.point;

    add(CircleHitbox(
        radius: 10.0, position: Vector2.zero(), anchor: Anchor.center));

    // After our parent is loaded, we need to add our children - we've got our
    // primary point renderer, our two handle squares, and the lines connecting
    // the handle squares to the body.
    if (point.handles != null) {
      final Paint handlePainter = Paint()..color = const Color(0xfff44c32);
      const handleSize = 5.0;

      handle1 = RectangleComponent.square(
          position: point.handles!.first,
          size: handleSize,
          angle: pi / 4,
          anchor: Anchor.center,
          paint: handlePainter);

      handle2 = RectangleComponent.square(
          position: point.handles!.last,
          size: handleSize,
          angle: pi / 4,
          anchor: Anchor.center,
          paint: handlePainter);

      handleBar1 = LineSegment(Vector2.zero(), point.handles!.first,
          color: 0xff484848, thickness: 2.0);
      handleBar2 = LineSegment(Vector2.zero(), point.handles!.last,
          color: 0xff484848, thickness: 2.0);

      // Add the handles as children
      addAll([handleBar1!, handleBar2!, handle1!, handle2!]);
    }

    // Add the primary point as a child
    pointMarker = CircleComponent(
        radius: 10.0,
        position: Vector2.zero(),
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xff5cc986));

    // Print out segment info!
    print("Howdy! My position is ${point.point}");
    print(
        "Hi! What's my segment info? Glad you asked! It's ${trailingSegment?.controlPoints}, ${leadingSegment?.controlPoints}");

    add(pointMarker);
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    // If we're dragging...
    if (!isDragging) return false;

    // Get the coordinates in game-space
    final gameCoords = info.eventPosition.game;

    Vector2 newPosition = gameCoords - dragDeltaPosition!;
    // Our position is equal to the drag's game coordinate position, minus the
    // starting drag delta. It's weird, and I don't fully understand it, but it
    // works.
    position = newPosition;

    // Our point's *actual* position is just the drag event's position
    point.point = gameCoords;

    // Update trailing / leading segments
    if (trailingSegment != null && trailingSegment!.isLoaded) {
      trailingSegment!.refreshPoints();
    }
    if (leadingSegment != null && leadingSegment!.isLoaded) {
      leadingSegment!.refreshPoints();
    }

    info.handled = true;
    return false;
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    dragDeltaPosition = null;
    info.handled = true;
    return false;
  }

  @override
  bool onDragCancel() {
    dragDeltaPosition = null;
    return false;
  }

  @override
  bool onDragStart(DragStartInfo info) {
    dragDeltaPosition = info.eventPosition.game - position;
    info.handled = true;
    return false;
  }
}
