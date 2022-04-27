import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:system_theme/system_theme.dart';
import 'package:track_tool/widgets/ride_editor_viewport.dart';
import 'package:track_tool/widgets/window/window_buttons.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemTheme.accentColor.load();

  await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden,
        windowButtonVisibility: false);
    await windowManager.center();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int paneIndex = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
        title: "TrackTool",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            accentColor: Colors.blue,
            iconTheme: const IconThemeData(size: 24)),
        darkTheme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            accentColor: Colors.blue,
            iconTheme: const IconThemeData(size: 24)),
        home: NavigationView(
          appBar: NavigationAppBar(
              automaticallyImplyLeading: false,
              title: () {
                if (kIsWeb) return const Text("TrackTool");
                return const DragToMoveArea(
                    child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text("TrackTool")));
              }(),
              actions: kIsWeb
                  ? null
                  : DragToMoveArea(
                      child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [Spacer(), WindowButtons()],
                    ))),
          pane: NavigationPane(
            selected: paneIndex,
            onChanged: (i) => setState(() => paneIndex = i),
            displayMode: PaneDisplayMode.top,
            indicator: const StickyNavigationIndicator(
              duration: Duration(milliseconds: 50),
              curve: Curves.easeOut,
            ),
            items: [
              PaneItem(
                  icon: const Icon(FluentIcons.border_inside),
                  title: const Text("Define Facility")),
              PaneItem(
                  icon: const Icon(FluentIcons.pen_workspace),
                  title: const Text("Layout Track")),
              PaneItem(
                  icon: const Icon(FluentIcons.flow),
                  title: const Text("Edit Motion"))
            ],
          ),
          content: NavigationBody(
            index: paneIndex,
            children: const [
              RideEditorViewportWidget(),
              Text("Layout Track"),
              Text("Motion thing")
            ],
          ),
        ));
  }
}
