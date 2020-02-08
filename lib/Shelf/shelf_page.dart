import 'package:flutter/material.dart';
import 'package:self_comic/explorer.dart';

class ShelfPage extends StatefulWidget {
  @override
  _ShelfPageState createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shelf')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Explorer.show(context, (path) {});
        },
      ),
    );
  }
}
