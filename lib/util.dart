import 'dart:io';

List<File> loadDir(String path) {
  return Directory(path).listSync().where((ii) => ii is File).map((ii) => ii as File).toList()..sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
}

File getCoverFile(String path) {
  return loadDir(path).first;
}

Future<FileSystemEntity> deleteLocal(String path) {
  return Directory(path).delete(recursive: true);
}
