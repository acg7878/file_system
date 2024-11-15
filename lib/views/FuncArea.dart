import 'package:flutter/material.dart' as material;
import 'package:fluent_ui/fluent_ui.dart';

class FuncArea extends StatefulWidget {
  const FuncArea({super.key});

  @override
  _FuncAreaState createState() => _FuncAreaState();
}

class _FuncAreaState extends State<FuncArea> {
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
              '磁盘块',
              style: TextStyle(
                color: material.Colors.black, // 文字颜色
                fontSize: 20, // 文字大小
                fontWeight: FontWeight.bold, // 文字加粗
              ),
            ),
          ),
         
         
          Expanded(
            child: Center(
              
            ),
          ),
        ],
      ),
    );
  }
}
