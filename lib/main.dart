import 'dart:io';

import 'package:flutter/material.dart';
import 'package:self_comic/Shelf/shelf_page.dart';
import 'package:flutter/services.dart';

const NAME = 'Self Comic';
void main() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: NAME,
      theme: ThemeData(primaryColor: Colors.blue),
      home: ShelfPage(),
    );
  }
}
