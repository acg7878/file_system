import 'package:flutter/material.dart';
import 'package:file_system/modles/FAT.dart';
import 'package:file_system/utils/FAT_utils.dart' as fat_utils;
class FuncArea extends StatefulWidget {
  final FAT fat;
  const FuncArea({super.key, required this.fat});

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
          // 标题
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              '磁盘块信息',
              style: TextStyle(
                color: Colors.black, // 文字颜色
                fontSize: 20, // 文字大小
                fontWeight: FontWeight.bold, // 文字加粗
              ),
            ),
          ),
          // 表格
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 40.0, // 缩小列间距
                  headingRowHeight: 40.0, // 调整表头高度
                  border: TableBorder.all(color: Colors.grey),
                  columns: const [
                    DataColumn(label: Text('块号')),
                    DataColumn(label: Text('状态')),
                    DataColumn(label: Text('类型')),
                    DataColumn(label: Text('名称')),
                  ],
                  rows: widget.fat.diskBlocks.map((block) {
                    return DataRow(
                      cells: [
                        DataCell(Text('${block.blockNumber}')), // 块号
                        DataCell(Text(
                          block.state.toString().split('.').last, // 状态枚举
                          style: TextStyle(
                            color: block.state == fat_utils.State.FREE
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        DataCell(Text(
                          block.type.toString().split('.').last, // 类型枚举
                        )),
                        DataCell(Text(
                          block.folder?.name ??
                              block.file?.fileName ??
                              '无', // 显示文件夹或文件名
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
