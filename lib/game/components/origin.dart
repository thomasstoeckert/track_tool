import 'package:flame/components.dart';
import 'package:flame_svg/svg.dart';
import 'package:flame_svg/svg_component.dart';
import 'package:track_tool/game/renderer.dart';

class OriginMarker extends SvgComponent with HasGameRef<RideEditorViewport> {
  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    // Load our origin image
    svg = await gameRef.loadSvg('vectors/origin.svg');

    // Assign our position to the world origin
    position = gameRef.size / 2;
    //position = Vector2.all(100);
    //size = Vector2.all(100);
    // Set our size to something nominal
    size = Vector2.all(256);
    scale = Vector2.all(0.5);
    // Center on the screen
    anchor = Anchor.center;
  }
}
