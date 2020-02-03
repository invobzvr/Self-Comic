import 'package:flutter/material.dart';

class ReaderPage extends StatefulWidget {
  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  bool ready = false;

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context).settings.arguments;
    return Container(
      child: ready ? Text(url) : Center(child: CircularProgressIndicator()),
    );
  }
}
