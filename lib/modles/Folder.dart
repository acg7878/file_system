import 'package:file_system/utils/FAT_utils.dart';
import 'File.dart';
class Folder {
  String name;
  Type type;
  int diskNum;
  Folder? parentFolder;
  List<Folder> childrenFolder = [];
  List<File> childrenFile = [];


  Folder({
    required this.name,
    this.type=Type.FOLDER,
    required this.diskNum,
    this.parentFolder,
  });
}

