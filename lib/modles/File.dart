import 'package:file_system/modles/Folder.dart';
import 'package:file_system/utils/FAT_utils.dart';
//import 'Path.dart';

class File {
  String fileName;
  Type type;
  int diskNum;
  Folder parentFolder; // 至少有个父文件夹是C:
  DateTime createTime;
  String content;
  bool isReadOnly = false;
  File({
    required this.fileName,
    this.type = Type.FILE,
    required this.diskNum,
    required this.parentFolder,
    this.content = '',
    DateTime? createTime,
    
  }) : createTime = createTime ?? DateTime.now();
}