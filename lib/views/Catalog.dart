import 'package:flutter/material.dart';

class Catalog extends StatelessWidget {
  const Catalog({super.key});

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
                color: Colors.black, // 文字颜色
                fontSize: 20, // 文字大小
                fontWeight: FontWeight.bold, // 文字加粗
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '内容区域',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
