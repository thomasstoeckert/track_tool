import 'dart:math';

import 'package:flame/components.dart';
import 'package:track_tool/game/renderer.dart';

class Player extends SpriteComponent with HasGameRef<RideEditorViewport> {
  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('player-sprite.jpeg');

    position = gameRef.size / 2;
    const scaleFactor = 0.1;
    width = (sprite?.image.width.toDouble() ?? 100) * scaleFactor;
    height = (sprite?.image.height.toDouble() ?? 150) * scaleFactor;
    anchor = Anchor.center;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  double lastMove = 0;

  @override
  void update(double dt) {
    super.update(dt);

    // Move randomly
    if (gameRef.currentTime() - lastMove > 1) {
      position = Vector2.random();
      position = Matrix2(position.x, 0, 0, position.y) * (gameRef.size);
      lastMove = gameRef.currentTime();
    }
  }
}
