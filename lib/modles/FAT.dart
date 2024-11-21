import 'package:file_system/modles/DiskBlock.dart';
import 'package:file_system/utils/FAT_utils.dart';
import 'Folder.dart';
import 'File.dart';
import 'Path.dart';

class FAT {
  late Folder rootFolder; //初始文件夹
  late Path rootPath; //初始路径
  late Path curPath;
  List<DiskBlock> diskBlocks = [];

  FAT() {
    diskBlocks = List.generate(
        128,
        (index) =>
            DiskBlock(blockNumber: index, state: State.FREE, type: Type.NULL));
    rootFolder = Folder(name: 'C:', diskNum: 0);
    rootPath = Path(name: 'C:', diskNum: 0);
    curPath = rootPath;
    diskBlocks[0] = DiskBlock(
        blockNumber: 0,
        state: State.USED,
        type: Type.DISK,
        folder: rootFolder);
  }

  int findFreeBlock() {
    for (int i = 1; i < diskBlocks.length; i++) {
      if (diskBlocks[i].state == State.FREE) {
        return i;
      }
    }
    return -1;
  }

  int createFolder(Path parentPath) {
    int freeBlockIndex = findFreeBlock();
    if (freeBlockIndex == -1) {
      return -1; // 没有空闲块
    }
    // 自动命名文件夹
    String baseName = '文件夹';
    int folderIndex = 1;
    String folderName = '$baseName$folderIndex';
    while (parentPath.children.any((child) => child.name == folderName)) {
      folderIndex++;
      folderName = '$baseName$folderIndex';
    }
    Folder newFolder = Folder(name: folderName, diskNum: freeBlockIndex);
    diskBlocks[parentPath.diskNum]
        .folder!
        .childrenFolder
        .add(newFolder); //添加新创建的文件夹到父文件夹里面
    diskBlocks[freeBlockIndex] = DiskBlock(
      blockNumber: freeBlockIndex,
      state: State.USED,
      type: Type.FOLDER,
      folder: newFolder,
    );
    diskBlocks[parentPath.diskNum]
        .folder!
        .childrenFolder
        .add(newFolder); //添加新创建的文件夹到父文件夹里面
    Path newPath =
        Path(name: folderName, parentPath: parentPath, diskNum: freeBlockIndex);
    parentPath.children.add(newPath);
    printStructure();
    return freeBlockIndex;
  }

  int createFile(Path parentPath) {
    int freeBlockIndex = findFreeBlock();
    if (freeBlockIndex == -1) {
      return -1; // 没有空闲块
    }

    // 自动命名文件
    String baseName = '文件';
    int fileIndex = 1;
    String fileName = '$baseName$fileIndex';
    while (parentPath.children.any((child) => child.name == fileName)) {
      fileIndex++;
      fileName = '$baseName$fileIndex';
    }
    // TODO
    File newFile = File(
        fileName: fileName,
        diskNum: freeBlockIndex,
        parentFolder: diskBlocks[parentPath.diskNum].folder!);
    // parentFolder: diskBlocks[parentPath.diskNum].folder!
    // 通过路径的硬盘号找到Folder对象
    diskBlocks[freeBlockIndex] = DiskBlock(
      blockNumber: freeBlockIndex,
      state: State.USED,
      type: Type.FILE,
      file: newFile,
    );
    Path newPath =
        Path(name: fileName, parentPath: parentPath, diskNum: freeBlockIndex);
    newPath.isFolder = false;//TODO
    parentPath.children.add(newPath);
    diskBlocks[parentPath.diskNum]
        .folder!
        .childrenFile
        .add(newFile); //添加新创建的文件到父文件夹里面
    printStructure();
    return freeBlockIndex;
  }

  bool deleteFolder(Path parentPath, String folderName) {
    try {
      // 找到需要删除的文件夹
      Path folderPath = parentPath.children.firstWhere(
        (child) =>
            child.name == folderName &&
            diskBlocks[child.diskNum].type == Type.FOLDER,
        orElse: () => throw Exception('Folder not found'),
      );

      // 获取文件夹对象
      Folder folderToDelete = diskBlocks[folderPath.diskNum].folder!;

      // 删除文件夹内的所有文件和子文件夹（递归删除）
      // 删除文件夹内的所有文件
      for (var file in List.from(folderToDelete.childrenFile)) {
        // 释放文件的磁盘块
        diskBlocks[file.diskNum] = DiskBlock(
          blockNumber: file.diskNum,
          state: State.FREE, // 释放磁盘块
          type: Type.NULL,
        );
        folderToDelete.childrenFile.remove(file); // 移除文件
        print("文件 ${file.fileName} 已删除");
      }

      // 递归删除所有子文件夹
      for (var subFolder in List.from(folderToDelete.childrenFolder)) {
        // 删除子文件夹
        deleteFolder(folderPath, subFolder.name); // 递归删除
      }

      // 从父文件夹的 childrenFolder 中移除文件夹
      diskBlocks[parentPath.diskNum]
          .folder!
          .childrenFolder
          .remove(folderToDelete);

      // 从父路径的 children 中移除路径
      parentPath.children.remove(folderPath);

      // 释放磁盘块
      diskBlocks[folderPath.diskNum] = DiskBlock(
        blockNumber: folderPath.diskNum,
        state: State.FREE, // 释放磁盘块
        type: Type.NULL,
      );

      // 输出文件系统结构，方便调试
      printStructure();
      return true; // 删除成功
    } catch (e) {
      print('Error deleting folder: $e');
      return false; // 删除失败
    }
  }

  bool deleteFile(Path parentPath, String fileName) {
    try {
      // 找到需要删除的文件
      Path filePath = parentPath.children.firstWhere(
        (child) =>
            child.name == fileName &&
            diskBlocks[child.diskNum].type == Type.FILE,
        orElse: () => throw Exception('File not found'),
      );

      // 获取文件对象
      File fileToDelete = diskBlocks[filePath.diskNum].file!;

      // 从父文件夹的 childrenFile 中移除文件
      diskBlocks[parentPath.diskNum].folder!.childrenFile.remove(fileToDelete);

      // 从父路径的 children 中移除路径
      parentPath.children.remove(filePath);

      // 释放磁盘块
      diskBlocks[filePath.diskNum] = DiskBlock(
        blockNumber: filePath.diskNum,
        state: State.FREE, // 释放磁盘块
        type: Type.NULL,
      );

      // 输出文件系统结构，方便调试
      printStructure();

      return true; // 删除成功
    } catch (e) {
      print('Error deleting file: $e');
      return false; // 删除失败
    }
  }

  // 新增：打印文件系统结构
  void printStructure({Path? currentPath, int indentLevel = 0}) {
    currentPath ??= rootPath; // 如果没有指定路径，则从根路径开始
    // 打印当前路径的信息
    print(' ' * indentLevel + currentPath.name);
    // 打印该路径下的文件和文件夹
    for (var child in currentPath.children) {
      DiskBlock block = diskBlocks[child.diskNum];
      if (block.type == Type.FOLDER) {
        printStructure(currentPath: child, indentLevel: indentLevel + 2);
      } else if (block.type == Type.FILE) {
        print(' ' * (indentLevel + 2) + block.file!.fileName); // 文件
      }
    }
  }
}
