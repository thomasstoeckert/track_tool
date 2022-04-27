import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:track_tool/game/components/origin.dart';
import 'package:track_tool/game/components/player.dart';

class RideEditorViewport extends FlameGame with PanDetector, ScrollDetector {
  late Player player;
  late Player anotherPlayer;

  late PositionComponent cameraOrigin;

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    player = Player();
    anotherPlayer = Player();

    cameraOrigin = PositionComponent(position: size / 2, anchor: Anchor.center);
    camera.followComponent(cameraOrigin);

    add(OriginMarker());
    add(cameraOrigin);
    add(player);
    add(anotherPlayer);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    //cameraOrigin.position.moveToTarget(info.delta.global, 1.0);
    cameraOrigin.position.add(-info.delta.game);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    // Move in / out with scrolling
    super.onScroll(info);
    camera.zoom =
        (camera.zoom * 1 - camera.zoom * (info.scrollDelta.game.y / 100.0))
            .clamp(0.01, 10.0);
  }
}
