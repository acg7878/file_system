import 'package:file_system/modles/Folder.dart';
import 'File.dart';
import 'package:file_system/utils/FAT_utils.dart';

class DiskBlock {
  int blockNumber;
  State state;
  Type type;
  Folder? folder;
  File? file;
  DiskBlock({
    required this.blockNumber,
    required this.state,
    required this.type,
    this.folder,
    this.file,
  });
}
