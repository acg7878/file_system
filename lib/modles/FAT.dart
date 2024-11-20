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
        type: Type.FOLDER,
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
    parentPath.children.add(newPath);
    diskBlocks[parentPath.diskNum].folder!.childrenFile.add(newFile);//TODO
    printStructure();
    return freeBlockIndex;
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
