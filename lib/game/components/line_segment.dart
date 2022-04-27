import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:fluent_ui/fluent_ui.dart';

class LineSegment extends RectangleComponent {
  final Vector2 pos1, pos2;

  LineSegment(this.pos1, this.pos2)
      : super(
            // Calculate the angle between straight-right (1, 0) and the relative
            // position vector of the destination
            angle: Vector2(1, 0).angleToSigned(pos2 - pos1),
            // Center the line segment along its center
            anchor: const Anchor(0.0, 0.5),
            position: pos1,
            size: Vector2(pos1.distanceTo(pos2), 20),
            paint: Paint()..color = const Color(0xff00ffff));
}
