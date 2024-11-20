import 'package:flutter/material.dart';
import 'package:file_system/modles/FAT.dart';
import 'package:file_system/modles/Path.dart';
import 'package:file_system/utils/FAT_utils.dart' as fat_utils;

class Catalog extends StatefulWidget {
  final FAT fat;
  final Path currentPath; // 当前路径
  final Function(Path) onPathSelected; // 路径选择回调

  const Catalog({
    super.key,
    required this.fat,
    required this.currentPath,
    required this.onPathSelected,
  });

  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {

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
              '目录',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
