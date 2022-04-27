import 'package:flame/game.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:track_tool/game/renderer.dart';

class RideEditorViewportWidget extends StatelessWidget {
  const RideEditorViewportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: RideEditorViewport());
  }
}
