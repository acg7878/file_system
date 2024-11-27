import 'package:flutter/material.dart';
import 'package:file_system/modles/Path.dart'; // 你的Path类

class Catalog extends StatefulWidget {
  final Path rootPath; // 根路径
  final ValueChanged<Path> onPathSelected; // 路径更新回调

  const Catalog({
    super.key,
    required this.rootPath,
    required this.onPathSelected,
  });

  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  late Path rootPath;

  @override
  void initState() {
    super.initState();
    rootPath = widget.rootPath;
  }

  // 构建树节点（文件夹和文件的通用处理）
  Widget _buildTreeNode(Path node, int depth) {
    return GestureDetector(
      onDoubleTap: node.isFolder ? () => widget.onPathSelected(node) : null,
      child: Padding(
        padding: EdgeInsets.only(left: depth * 8.0), // 减少缩进
        child: node.isFolder
            ? ExpansionTile(
                title: Row(
                  children: [
                    Icon(
                      node.children.isEmpty ? Icons.folder : Icons.folder_open,
                    ),
                    const SizedBox(width: 8), // 减小图标与文本间距
                    Text(
                      node.name,
                    ),
                  ],
                ),
                children: node.children
                    .map((child) => _buildTreeNode(child, depth + 1))
                    .toList(),
              )
            : ListTile(
                title: Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file,
                      size: 18, // 减小图标大小
                    ),
                    const SizedBox(width: 8), // 减小图标与文本间距
                    Text(
                      node.name,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 1)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('目录',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(children: [_buildTreeNode(rootPath, 0)]),
          ),
        ],
      ),
    );
  }
}
