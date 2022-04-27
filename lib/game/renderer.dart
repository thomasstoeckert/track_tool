import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:track_tool/game/components/background.dart';
import 'package:track_tool/game/components/control_point.dart';
import 'package:track_tool/game/components/curvy_line_segment.dart';
import 'package:track_tool/game/components/origin.dart';

class RideEditorViewport extends FlameGame
    with PanDetector, ScrollDetector, TapDetector {
  //late Player player;
  //late Player anotherPlayer;

  late PositionComponent cameraFocus;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    //player = Player();
    //anotherPlayer = Player();

    cameraFocus = PositionComponent(position: size / 2, anchor: Anchor.center);
    camera.followComponent(cameraFocus);

    add(Background());
    add(OriginMarker());
    add(cameraFocus);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    //cameraOrigin.position.moveToTarget(info.delta.global, 1.0);
    cameraFocus.position.add(-info.delta.game);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    // Move in / out with scrolling
    super.onScroll(info);
    camera.zoom =
        (camera.zoom * 1 - camera.zoom * (info.scrollDelta.game.y / 200.0))
            .clamp(0.05, 10.0);
  }

  ControlPoint? lastControlPoint;
  List<Vector2> lastFourPoints = [];

  @override
  void onTapDown(TapDownInfo info) {
    // Place a new *something* at the mouse cursor click point
    print("Placing player at ${info.eventPosition.game}");

    ControlPoint newControlPoint = ControlPoint(info.eventPosition.game);
    add(newControlPoint);

    lastFourPoints.add(info.eventPosition.game);

    if (lastControlPoint != null) {
      // Place a line between the newest point and the last one
      /*add(LineSegment(
          lastControlPoint!.initialPosition, info.eventPosition.game));*/
      print("Added a line segment");
    }

    if (lastFourPoints.length > 3) lastFourPoints.removeAt(0);

    if (lastFourPoints.length == 3) {
      // Build a curvy line
      add(CurvyLineSegment(lastFourPoints));
      lastFourPoints.removeRange(0, 2);
    }

    lastControlPoint = newControlPoint;
  }
}
