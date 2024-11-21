
class Path {
  String name;
  int diskNum;
  Path? parentPath;
  List<Path> children = [];
  bool isFolder;
  Path({
    required this.name,
    required this.diskNum,
    this.parentPath,
    this.isFolder = true,
  });

  String getAbsolutePath() {
    if (parentPath == null) {
      return name;
    } else {
      return '${parentPath!.getAbsolutePath()}/$name';
    }
  }
}