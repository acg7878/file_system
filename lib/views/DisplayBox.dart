import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:file_system/modles/FAT.dart';
import 'package:file_system/modles/File.dart'; // 引入 File 模块
import 'package:file_system/utils/FAT_utils.dart' as fat_utils;

class DisplayBox extends StatefulWidget {
  final FAT fat;
  final List<File> files; // 文件列表（File对象）
  final List<String> folders; // 文件夹列表
  final Function(String) onFolderTap; // 点击文件夹时的回调
  final Function(File) onDeleteFile; // 删除文件回调
  final Function(Path) onDeleteFolder; // 删除文件夹回调

  const DisplayBox({
    super.key,
    required this.fat,
    required this.files,
    required this.folders,
    required this.onFolderTap,
    required this.onDeleteFile,
    required this.onDeleteFolder,
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
            child: FluentUI.ListView(
              children: [
                // 显示文件夹
                ...widget.folders.map((folder) => FluentUI.ListTile(
                      leading: const Icon(FluentUI.FluentIcons.folder),
                      title: Text(folder),
                      onPressed: () => widget.onFolderTap(folder),
                    )),
                // 显示文件
                ...widget.files.map((file) => FluentUI.ListTile(
                      leading: const Icon(FluentUI.FluentIcons.file_code),
                      title: Text(file.fileName), // 显示文件名
                      onPressed: () => _editFile(file), // 点击文件时传递文件对象
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
