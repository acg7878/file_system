//import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onCreateFile;
  final VoidCallback onCreateFolder;
  final VoidCallback onBack;
  final String currentPath;
  const TopBar({
    super.key,
    required this.onCreateFile,
    required this.onCreateFolder,
    required this.onBack,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    //bool disabled = false;
    //String currentPath = "C:"; // 示例当前路径

    return Padding(
      padding: const EdgeInsets.all(8.0), // 设置所有方向的边距为 8.0
      child: Row(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(FluentIcons.chrome_back, size: 20.0),
                onPressed: onBack,
              ),
              //const SizedBox(width: 16),
              const Text(
                '当前路径: ',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(
                width: 500, // 设置 TextBox 的宽度
                child: TextBox(
                  placeholder: currentPath,
                  //onChanged: (value) => debugPrint('searching...'),
                  enabled: false,
                ),
              ), 
              // IconButton(
              //   icon: const Icon(FluentIcons.chrome_back_mirrored, size: 24.0),
              //   onPressed: disabled ? null : () => debugPrint('pressed button'),
              // ),
            ],
          ),
          const Spacer(), // 添加 Spacer 以将右边的按钮推到最右边
          FilledButton(
            onPressed: onCreateFile,
            child: const Text('新建文件'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onCreateFolder,
            child: const Text('新建文件夹'),
          )
        ],
      ),
    );
  }
}
