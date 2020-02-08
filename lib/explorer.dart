library explorer;

import 'dart:io';
import 'package:flutter/material.dart';

typedef ExplorerResult = void Function(String path);

List<String> listDirs(String path) {
  List<String> dirs = Directory(path).listSync().where((ii) => ii is Directory).map((ii) => ii.path.split('/').last).toList();
  dirs.sort();
  return dirs;
}

class Explorer {
  static void show(BuildContext context, ExplorerResult callback, [String root]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExplorerPage(callback, root ?? '/sdcard')),
    );
  }
}

class PBItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  PBItem(this.text, [this.onTap]);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: onTap != null ? 15 : 5),
          child: Text(
            text,
            style: TextStyle(color: onTap != null ? Colors.white : Colors.black38),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

class ExplorerPage extends StatefulWidget {
  final String root;
  final ExplorerResult callback;

  ExplorerPage(this.callback, this.root);

  @override
  _ExplorerPageState createState() => _ExplorerPageState(callback, root);
}

class _ExplorerPageState extends State<ExplorerPage> {
  String root;
  String current;
  ExplorerResult callback;
  List<String> paths;

  _ExplorerPageState(this.callback, this.root) {
    if (!root.startsWith('/')) {
      root = '/$root';
    }
    current = root;
    paths = root.split('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorer'),
        bottom: PreferredSize(
          preferredSize: Size(0, 39),
          child: Container(
            height: 39,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: paths.length,
              separatorBuilder: (ctx, idx) => PBItem('>'),
              itemBuilder: (ctx, idx) => PBItem(
                paths[idx] != '' ? paths[idx] : '/',
                () => setState(() {
                  paths = paths.sublist(0, idx + 1);
                  current = paths.join('/');
                }),
              ),
            ),
          ),
        ),
      ),
      body: Builder(builder: (context) => lvBuilder(context)),
    );
  }

  ListView lvBuilder(BuildContext context) {
    List<String> list = listDirs(current);
    return ListView.separated(
      itemCount: list.length,
      separatorBuilder: (ctx, idx) => Divider(height: 0),
      itemBuilder: (ctx, idx) => ListTile(
        leading: Icon(
          Icons.folder,
          color: Colors.blue,
        ),
        title: Text(list[idx]),
        onTap: () => setState(() {
          paths.add(list[idx]);
          current = paths.join('/');
        }),
        onLongPress: () {
          String selected = '${paths.join('/')}/${list[idx]}';
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(selected),
            action: SnackBarAction(
              label: 'Select',
              onPressed: () {
                callback(selected);
                Navigator.pop(context);
              },
            ),
          ));
        },
      ),
    );
  }
}
