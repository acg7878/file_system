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
    return Padding(
      padding: const EdgeInsets.all(8.0), // 设置所有方向的边距为 8.0
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(FluentIcons.chrome_back, size: 20.0),
                  onPressed: onBack,
                ),
                const Text(
                  '当前路径: ',
                  style: TextStyle(fontSize: 16.0),
                ),
                Expanded(
                  child: TextBox(
                    placeholder: currentPath,
                    enabled: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onCreateFile,
            child: const Text('新建文件'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onCreateFolder,
            child: const Text('新建文件夹'),
          ),
        ],
      ),
    );
  }
}
