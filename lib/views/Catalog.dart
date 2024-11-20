import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:file_system/modles/FAT.dart';

class Catalog extends StatefulWidget {
  final FAT fat;
  const Catalog({super.key, required this.fat});

  @override
  _CatalogState createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
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
              '目录',
              style: TextStyle(
                color: material.Colors.black, // 文字颜色
                fontSize: 20, // 文字大小
                fontWeight: FontWeight.bold, // 文字加粗
              ),
            ),
          ),
          const Expanded(
            child: Center(),
          ),
        ],
      ),
    );
  }
}
