import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as FluentUI;
import 'package:file_system/modles/FAT.dart';
import 'package:file_system/modles/Path.dart' as file_system;

class DisplayBox extends StatefulWidget {
  final FAT fat;
  final List<String> files; // 当前路径下的文件
  final List<String> folders; // 当前路径下的文件夹
  final Function(String) onFolderTap; // 点击文件夹时的回调

  const DisplayBox({
    super.key,
    required this.fat,
    required this.files,
    required this.folders,
    required this.onFolderTap,
  });

  @override
  _DisplayBoxState createState() => _DisplayBoxState();
}

class _DisplayBoxState extends State<DisplayBox> {
  void _editFile(String fileName) {
    final file = widget.fat.diskBlocks
        .firstWhere((block) => block.file?.fileName == fileName)
        .file;

    if (file == null) return;

    TextEditingController controller = TextEditingController(text: file.content);

    showDialog(
      context: context,
      builder: (context) {
        return FluentUI.ContentDialog(
          title: Text('编辑文件: $fileName'),
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
                  file.content = controller.text;
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
                ...widget.folders.map((folder) => FluentUI.ListTile(
                      leading: const Icon(FluentUI.FluentIcons.folder),
                      title: Text(folder),
                      onPressed: () => widget.onFolderTap(folder),
                    )),
                ...widget.files.map((file) => FluentUI.ListTile(
                      leading: const Icon(FluentUI.FluentIcons.file_code),
                      title: Text(file),
                      onPressed: () => _editFile(file),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
