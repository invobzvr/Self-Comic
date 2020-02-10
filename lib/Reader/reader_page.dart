import 'dart:io';

import 'package:flutter/material.dart';

List<File> loadDir(String path) {
  return Directory(path).listSync().where((ii) => ii is File).map((ii) => ii as File).toList()..sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
}

class ReaderPage extends StatefulWidget {
  final String path;

  ReaderPage(this.path);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  Widget build(BuildContext context) {
    List<File> files = loadDir(widget.path);
    return PageView.builder(
      itemCount: files.length,
      itemBuilder: (ctx, idx) => Image.file(files[idx]),
    );
  }
}
