//import 'package:file_system/utils/FAT_utils.dart';

class Path {
  String name;
  int diskNum;
  Path? parentPath;
  List<Path> children = [];

  Path({
    required this.name,
    required this.diskNum,
    this.parentPath,
  });
}