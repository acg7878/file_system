import 'package:fluent_ui/fluent_ui.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    bool disabled = false;
    String currentPath = "C:"; // 示例当前路径

    return Padding(
      padding: const EdgeInsets.all(8.0), // 设置所有方向的边距为 8.0
      child: Row(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(FluentIcons.chrome_back, size: 24.0),
                onPressed: disabled ? null : () => debugPrint('pressed button'),
              ),
              //const SizedBox(width: 16),
              const Text(
                '当前路径: ',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(
                width: 200, // 设置 TextBox 的宽度
                child: TextBox(
                  placeholder: '$currentPath',
                  //onChanged: (value) => debugPrint('searching...'),
                  enabled: false,
                ),
              ), 
              IconButton(
                icon: const Icon(FluentIcons.chrome_back_mirrored, size: 24.0),
                onPressed: disabled ? null : () => debugPrint('pressed button'),
              ),
            ],
          ),
          const Spacer(), // 添加 Spacer 以将右边的按钮推到最右边
          Button(
            child: const Text('新建文件'),
            onPressed: disabled ? null : () => debugPrint('pressed button'),
          ),
          const SizedBox(width: 8),
          Button(
            child: const Text('新建文件夹'),
            onPressed: disabled ? null : () => debugPrint('pressed button'),
          )
        ],
      ),
    );
  }
}
