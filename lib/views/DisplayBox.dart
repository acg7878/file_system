import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:file_system/modles/FAT.dart';
import 'package:file_system/modles/File.dart'; // 引入 File 模块
import 'package:file_system/utils/FAT_utils.dart' as fat_utils;
import 'package:file_system/modles/Path.dart';
import 'package:file_system/modles/Folder.dart'; // 引入 Folder 模块
import 'package:context_menus/context_menus.dart';

class DisplayBox extends StatefulWidget {
  final FAT fat;
  final List<File> files; // 文件列表（File对象）
  final List<String> folders; // 文件夹列表
  final Function(String) onFolderTap; // 点击文件夹时的回调
  final VoidCallback onUpdate;

  const DisplayBox({
    super.key,
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
  // 修改 _editFile 接受 File 对象作为参数
  void _editFile(File file) {
    // 获取文件内容
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

  void _deleteFile(Path currentPath, String fileName) {
    bool success = widget.fat.deleteFile(currentPath, fileName); // 使用当前路径和文件名删除
    if (success) {
      setState(() {
      widget.files.removeWhere((file) => file.fileName == fileName); // 从文件列表中移除文件
      widget.onUpdate(); 
    });
      print("文件 $fileName 已删除");
    } else {
      print("删除文件失败");
    }
  }

  // 右键删除文件夹
  void _deleteFolder(Path currentPath, String folderName) {
    // 调用 FAT 类中的 deleteFolder 方法来删除文件夹
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
          color: Colors.black, // 边框颜色
          width: 1, // 边框宽度
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
                color: Colors.black, // 文字颜色
                fontSize: 20, // 文字大小
                fontWeight: FontWeight.bold, // 文字加粗
              ),
            ),
          ),
          Expanded(
            child: ContextMenuOverlay(
              child: FluentUI.ListView(
                children: [
                  // 显示文件夹
                  ...widget.folders.map((folder) => ContextMenuRegion(
                        contextMenu: GenericContextMenu(
                          buttonConfigs: [
                            ContextMenuButtonConfig("删除文件夹",
                                onPressed: () => _deleteFolder(widget.fat.curPath, folder)),
                          ],
                        ),
                        child: FluentUI.ListTile(
                          leading: const Icon(FluentUI.FluentIcons.folder),
                          title: Text(folder),
                          onPressed: () => widget.onFolderTap(folder),
                        ),
                      )),
                  // 显示文件
                  ...widget.files.map((file) => ContextMenuRegion(
                        contextMenu: GenericContextMenu(
                          buttonConfigs: [
                            ContextMenuButtonConfig("删除文件",
                                onPressed: () =>
                                    _deleteFile(widget.fat.curPath, file.fileName)),
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
