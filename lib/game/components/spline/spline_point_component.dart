import 'dart:math';

import 'package:flame/components.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:track_tool/data/spline_point.dart';
import 'package:track_tool/game/components/line_segment.dart';

class SplinePointComponent extends PositionComponent {
  bool showHandles = false;
  SplinePoint point;

  SplinePointComponent(this.point, {this.showHandles = false});

  late RectangleComponent? handle1, handle2;
  late RectangleComponent? handleBar1, handleBar2;
  late CircleComponent pointMarker;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

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

      handleBar1 = LineSegment(point.point, point.handles!.first,
          color: 0xff484848, thickness: 2.0);
      handleBar2 = LineSegment(point.point, point.handles!.last,
          color: 0xff484848, thickness: 2.0);

      // Add the handles as children
      addAll([handleBar1!, handleBar2!, handle1!, handle2!]);
    }

    // Add the primary point as a child
    pointMarker = CircleComponent(
        radius: 10.0,
        position: point.point,
        anchor: Anchor.center,
        paint: Paint()..color = const Color(0xff5cc986));

    add(pointMarker);
  }
}
