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
  late Path curPath;

  @override
  void initState() {
    super.initState();
    fat = FAT();
    curPath = fat.rootPath; // 初始化路径为根路径
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
        fat.curPath = curPath; // 同步更新 FAT 的路径
      }
    });
  }

  void _onPathSelected(Path newPath) {
    setState(() {
      curPath = newPath;
      fat.curPath = newPath; // 同步 FAT 中的路径
    });
  }

  void _onUpdate() {
    setState(() {
      // 触发整个界面的重建，包括功能区和文件显示
    });
  }

  @override
  Widget build(BuildContext context) {
    return FluentUI.FluentApp(
      home: Scaffold(
        backgroundColor: FluentUI.Colors.white, // 设置 Scaffold 背景颜色
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: TopBar(
                  onCreateFolder: _createFolder,
                  onCreateFile: _createFile,
                  onBack: _goBack,
                  currentPath: curPath.getAbsolutePath(),
                ),
              ),
              Expanded(
                flex: 9,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Catalog(
                        rootPath: fat.rootPath, // 目录树的根路径
                        onPathSelected: _onPathSelected, // 选中路径时的回调
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: DisplayBox(
                        curPath: curPath,
                        fat: fat,
                        files: curPath.children
                            .where((child) =>
                                fat.diskBlocks[child.diskNum].type ==
                                fat_utils.Type.FILE)
                            .map((child) =>
                                fat.diskBlocks[child.diskNum].file!) // 传入文件对象
                            .toList(),
                        folders: curPath.children
                            .where((child) =>
                                fat.diskBlocks[child.diskNum].type ==
                                fat_utils.Type.FOLDER)
                            .map((child) => child.name)
                            .toList(),
                        onFolderTap: (folderName) {
                          setState(() {
                            // 找到目标文件夹对应的路径
                            Path selectedPath = curPath.children.firstWhere(
                              (child) =>
                                  child.name == folderName &&
                                  fat.diskBlocks[child.diskNum].type ==
                                      fat_utils.Type.FOLDER,
                            );
                            // 更新 FAT 的当前路径
                            fat.curPath = selectedPath;
                            // 同步更新本地的 curPath
                            curPath = fat.curPath;
                          });
                        },
                        onUpdate: _onUpdate,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FuncArea(fat: fat),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
