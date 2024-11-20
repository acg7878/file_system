import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:file_system/views/Catalog.dart';
import 'package:file_system/views/DisplayBox.dart';
import 'package:file_system/views/FuncArea.dart';
import 'package:file_system/views/TopBar.dart';
import 'package:file_system/modles/FAT.dart';
import 'package:file_system/modles/Path.dart';
import 'package:file_system/utils/FAT_utils.dart' as fat_utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1100, 750),
    center: true,
    backgroundColor: FluentUI.Colors.white, // 设置背景颜色为白色
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setMinimumSize(const Size(1100, 750));
    await windowManager.setMaximumSize(const Size(1100, 750));
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const FluentUI.FluentApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FAT fat;
  late Path rootPath;
  late Path curPath;

  @override
  void initState() {
    super.initState();
    fat = FAT();
    rootPath = fat.rootPath;
    curPath = fat.curPath;
  }

  void _createFolder() {
    setState(() {
      fat.createFolder(curPath);
    });
  }

  void _createFile() {
    setState(() {
      fat.createFile(curPath);
    });
  }

  void _goBack() {
    setState(() {
      if (curPath.parentPath != null) {
        curPath = curPath.parentPath!;
      }
    });
  }

   void _onUpdate() {
    setState(() {
      // 触发整个界面的重建，包括 FuncArea
    });
  }
  @override
  Widget build(BuildContext context) {
    return FluentUI.FluentApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50, // 设置具体的高度
                child: TopBar(
                  onCreateFolder: _createFolder,
                  onCreateFile: _createFile,
                  onBack: _goBack,
                  currentPath: curPath.getAbsolutePath(),
                ),
              ),
              Expanded(
                flex: 9, // 右边占30%
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Catalog(fat: fat),
                      ),
                      Expanded(
                          flex: 5, // 右边占30%
                          child: DisplayBox(
                            fat: fat, 
                            files: curPath.children
                                .where((child) =>
                                    fat.diskBlocks[child.diskNum].type ==
                                    fat_utils.Type.FILE)
                                .map((child) => fat.diskBlocks[child.diskNum]
                                    .file!) // 直接传入文件对象
                                .toList(),
                            folders: curPath.children
                                .where((child) =>
                                    fat.diskBlocks[child.diskNum].type ==
                                    fat_utils.Type.FOLDER)
                                .map((child) => child.name)
                                .toList(),
                            onFolderTap: (folderName) {
                              setState(() {
                                curPath = curPath.children.firstWhere(
                                  (child) =>
                                      child.name == folderName &&
                                      fat.diskBlocks[child.diskNum].type ==
                                          fat_utils.Type.FOLDER,
                                );
                              });
                            },
                            onUpdate: _onUpdate,
                          )),
                      Expanded(
                        flex: 3, // 右边占30%
                        child: FuncArea(fat: fat),
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
