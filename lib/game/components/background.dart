import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:track_tool/game/renderer.dart';

class Background extends SpriteBatchComponent
    with HasGameRef<RideEditorViewport> {
  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Load our background tile
    spriteBatch = await gameRef.loadSpriteBatch("BackgroundTile.png");

    // Fill the visible part of the screen

    for (double i = -256; i < gameRef.size.x + 256; i += 256) {
      for (double j = -256; j < gameRef.size.y + 256; j += 256) {
        spriteBatch!.addTransform(
            source: const Rect.fromLTWH(256, 0, 256, 256),
            color: const Color.fromARGB(255, 50, 50, 50),
            transform: RSTransform.fromComponents(
                rotation: 0,
                scale: 1.0,
                anchorX: 0,
                anchorY: 0,
                translateX: i.toDouble(),
                translateY: j.toDouble()));
      }
    }
  }

  @override
  void update(double dt) async {
    super.update(dt);

    // Fill a screen
    // Get the camera's transforms
    Vector2 camPosition = gameRef.camera.position;

    // Clear all batches
    spriteBatch!.clear();

    // Fill the viewport w/ tiles
    for (double i = -256; i < gameRef.size.x + 256; i += 256) {
      for (double j = -256; j < gameRef.size.y + 256; j += 256) {
        spriteBatch!.addTransform(
            source: const Rect.fromLTWH(256, 0, 256, 256),
            color: const Color.fromARGB(255, 50, 50, 50),
            transform: RSTransform.fromComponents(
                rotation: 0,
                scale: 1.0,
                anchorX: 0,
                anchorY: 0,
                translateX: (camPosition.x ~/ 256) * 256 + i,
                translateY: (camPosition.y ~/ 256) * 256 + j));
      }
    }
  }
}
