import 'package:flame/components.dart';
import 'package:fluent_ui/fluent_ui.dart';

class ControlPoint extends CircleComponent {
  final Vector2 initialPosition;
  ControlPoint(this.initialPosition);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Define our circle settings
    radius = 10;
    position = initialPosition - Vector2.all(radius);
    paint = Paint()..color = const Color(0xff00ffff);
  }
}
