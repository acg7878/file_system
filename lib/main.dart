import 'package:file_system/views/TopBar.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'views/Catalog.dart';
import 'views/DisplayBox.dart';
import 'views/FuncArea.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1100, 750),
    center: true,
    backgroundColor: Colors.transparent,
    //skipTaskbar: false,
    //titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setMinimumSize(const Size(1100, 750));
    await windowManager.setMaximumSize(const Size(1100, 750));
    await windowManager.show();
    await windowManager.focus();
  });
   runApp(FluentUI.FluentApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(
              height: 50, // 设置具体的高度
              child: TopBar(),
            ),
              Expanded(
                flex: 9, // 右边占30%
                child: Container(
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Catalog(),
                      ),
                      Expanded(
                        flex: 6, // 右边占30%
                        child: DisplayBox(),
                      ),
                      Expanded(
                        flex: 2, // 右边占30%
                        child: FuncArea(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
