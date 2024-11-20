import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:file_system/modles/FAT.dart';
import 'package:file_system/modles/File.dart';
//import 'package:file_system/utils/FAT_utils.dart' as fat_utils;
import 'package:file_system/modles/Path.dart';
//import 'package:file_system/modles/Folder.dart';
import 'package:context_menus/context_menus.dart';

class DisplayBox extends StatefulWidget {
  final FAT fat;
  final Path curPath;
  final List<File> files; // 文件列表（File对象）
  final List<String> folders; // 文件夹列表
  final Function(String) onFolderTap; // 点击文件夹时的回调
  final VoidCallback onUpdate;

  const DisplayBox({
    super.key,
    required this.curPath,
    required this.fat,
    required this.files,
    required this.folders,
    required this.onFolderTap,
    required this.onUpdate,
  });

  @override
  _DisplayBoxState createState() => _DisplayBoxState();
}

class _DisplayBoxState extends State<DisplayBox> {
  void _editFile(File file) {
    if (file.isReadOnly) {
      // 如果文件是只读的，直接展示内容
      showDialog(
        context: context,
        builder: (context) {
          return FluentUI.ContentDialog(
            title: Text('查看文件:${file.fileName}'),
            content: Text(file.content), // 仅展示文件内容
            actions: [
              FluentUI.Button(
                child: const Text('关闭'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return; // 如果是只读文件，阻止编辑
    }

    final controller = TextEditingController(text: file.content);
    showDialog(
      context: context,
      builder: (context) {
        return FluentUI.ContentDialog(
          title: Text('编辑文件: ${file.fileName}'),
          content: FluentUI.TextBox(
            controller: controller,
            maxLines: 10,
            placeholder: '请输入文件内容',
          ),
          actions: [
            FluentUI.Button(
              child: const Text('保存'),
              onPressed: () {
                setState(() {
                  file.content = controller.text; // 更新文件内容
                });
                Navigator.of(context).pop();
                controller.dispose();
              },
            ),
            FluentUI.Button(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
                controller.dispose();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleReadOnly(File file) {
    setState(() {
      file.isReadOnly = !file.isReadOnly; // 切换只读状态
    });
    print("文件 ${file.fileName} 状态已更新为 ${file.isReadOnly ? "只读" : "可编辑"}");
  }

  void _deleteFile(Path currentPath, String fileName) {
    bool success = widget.fat.deleteFile(currentPath, fileName);
    if (success) {
      setState(() {
        widget.files
            .removeWhere((file) => file.fileName == fileName); // 从文件列表中移除文件
        widget.onUpdate();
      });
      print("文件 $fileName 已删除");
    } else {
      print("删除文件失败");
    }
  }

  // 右键删除文件夹
  void _deleteFolder(Path currentPath, String folderName) {
    final success = widget.fat.deleteFolder(currentPath, folderName);

    if (success) {
      setState(() {
        widget.folders.remove(folderName); // 从文件夹列表中移除已删除的文件夹
        widget.onUpdate();
      });
      print("文件夹 $folderName 已删除");
    } else {
      print("删除文件夹失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              '文件管理',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ContextMenuOverlay(
              child: FluentUI.ListView(
                children: [
                  ...widget.folders.map((folder) => ContextMenuRegion(
                        contextMenu: GenericContextMenu(
                          buttonStyle: ContextMenuButtonStyle(
                            fgColor: Colors.black, // 设置文本的默认颜色
                            //bgColor: Colors.white, // 设置按钮的背景颜色
                            hoverFgColor: Colors.blue, // 设置鼠标悬停时的文本颜色
                            hoverBgColor: Colors.grey[300]!, // 设置鼠标悬停时的背景颜色
                            //padding: const EdgeInsets.symmetric(
                            //    horizontal: 16, vertical: 8), // 设置按钮的内边距
                          ),
                          buttonConfigs: [
                            ContextMenuButtonConfig("删除文件夹",
                                onPressed: () =>
                                    _deleteFolder(widget.fat.curPath, folder)),
                          ],
                        ),
                        child: FluentUI.ListTile(
                          leading: const Icon(FluentUI.FluentIcons.folder),
                          title: Text(folder),
                          onPressed: () => widget.onFolderTap(folder),
                        ),
                      )),
                  ...widget.files.map((file) => ContextMenuRegion(
                        contextMenu: GenericContextMenu(
                          buttonStyle: ContextMenuButtonStyle(
                            fgColor: Colors.black, 
                            hoverFgColor: Colors.blue, 
                            hoverBgColor: Colors.grey[300]!, 
                          ),
                          buttonConfigs: [
                            ContextMenuButtonConfig(
                                file.isReadOnly ? "设置为可编辑" : "设置为只读",
                                onPressed: () => _toggleReadOnly(file)),
                            ContextMenuButtonConfig("删除文件",
                                onPressed: () => _deleteFile(
                                    widget.curPath, file.fileName)),
                          ],
                        ),
                        child: FluentUI.ListTile(
                          leading: const Icon(FluentUI.FluentIcons.file_code),
                          title: Text(file.fileName),
                          onPressed: () => _editFile(file),
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
