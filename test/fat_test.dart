import 'package:flutter_test/flutter_test.dart';
import 'package:file_system/modles/DiskBlock.dart';
import 'package:file_system/modles/FAT.dart';
import 'package:file_system/modles/File.dart';
import 'package:file_system/modles/Folder.dart';
import 'package:file_system/modles/Path.dart';
import 'package:file_system/utils/FAT_utils.dart';

void main() {
  group('FAT', () {
    test('createFolder and createFile', () {
      FAT fat = FAT();
      
      // 创建文件夹和文件以测试
      Path rootPath = fat.rootPath;
      int folderIndex = fat.createFolder(rootPath);  // 创建一个文件夹
      fat.createFolder(rootPath);
      fat.createFolder(rootPath);
      fat.createFolder(rootPath);
      int fileIndex = fat.createFile(rootPath);    // 创建一个文件
      Path folderPath = rootPath.children[0];  // 获取新创建的文件夹路径
      int nestedFileIndex = fat.createFile(folderPath); // 在文件夹中创建一个文件
      
    
      fat.printStructure();
    });
  });
}
