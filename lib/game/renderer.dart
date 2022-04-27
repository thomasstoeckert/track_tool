import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:track_tool/data/spline.dart';
import 'package:track_tool/data/spline_point.dart';
import 'package:track_tool/game/components/background.dart';
import 'package:track_tool/game/components/origin.dart';
import 'package:track_tool/game/components/spline/spline_component.dart';

class RideEditorViewport extends FlameGame
    with PanDetector, ScrollDetector, TapDetector {
  //late Player player;
  //late Player anotherPlayer;

  late PositionComponent cameraFocus;
  late SplineComponent splineComponent;
  late Spline primarySpline;

  late TextComponent fpsLabel;

  String textComponentLabel = "0 FPS";

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    //player = Player();
    //anotherPlayer = Player();

    cameraFocus = PositionComponent(position: size / 2, anchor: Anchor.center);
    camera.followComponent(cameraFocus);
    primarySpline = Spline.fromPoints([
      SplinePoint.withHandles(Vector2(100, 100), handleScale: 45.0),
      SplinePoint.withHandles(Vector2(200, 200), handleScale: 45.0)
    ]);
    splineComponent = SplineComponent(Vector2.zero(), primarySpline);
    fpsLabel = TextComponent(
        text: textComponentLabel,
        position: Vector2(0 + 10, size.y),
        anchor: Anchor.bottomLeft)
      ..positionType = PositionType.viewport;

    add(Background());
    add(OriginMarker());
    add(splineComponent);
    add(cameraFocus);
    add(fpsLabel);
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

  @override
  void onTapDown(TapDownInfo info) {
    // Create a new spline point, positioned at the mouse cursor.
    final Vector2 gameTapPosition = info.eventPosition.game;
    final SplinePoint newPoint =
        SplinePoint.withHandles(gameTapPosition, handleScale: 45.0);

    // Tack it onto the current spline
    primarySpline.addPoint(newPoint);
  }

  @override
  void update(double dt) {
    textComponentLabel = "${(1 / dt).toStringAsFixed(0)} FPS";
    fpsLabel.text = textComponentLabel;
    super.update(dt);
  }
}
