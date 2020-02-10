library explorer;

import 'dart:io';
import 'package:flutter/material.dart';

List<String> listDir(String path) {
  return Directory(path).listSync().where((ii) => ii is Directory).map((ii) => ii.path.split('/').last).toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
}

class Explorer {
  static Future<String> show(BuildContext context, [String root]) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ExplorerPage(root ?? '/sdcard')),
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

  ExplorerPage(this.root);

  @override
  _ExplorerPageState createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  String current;
  String last;
  List<String> paths;
  ScrollController pController = ScrollController();

  @override
  void initState() {
    super.initState();
    current = widget.root.startsWith('/') ? widget.root : '/${widget.root}';
    paths = current.split('/');
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 0),
      () => pController.animateTo(
        pController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Explorer'),
        bottom: PreferredSize(
          preferredSize: Size(0, 39),
          child: Container(
            height: 39,
            child: pbBuilder(),
          ),
        ),
      ),
      body: Builder(builder: (context) => fseBuilder(context)),
    );
  }

  Widget pbBuilder() {
    return ListView.separated(
      controller: pController,
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
    );
  }

  Widget fseBuilder(BuildContext context) {
    List<String> list;
    try {
      list = listDir(current);
      last = current;
    } on FileSystemException catch (e) {
      return InkWell(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.red, size: 100),
              Text(e.osError.message, style: TextStyle(color: Colors.red, fontSize: 30)),
            ],
          ),
        ),
        onTap: () => setState(() => (paths = (current = last).split('/'))),
      );
    }
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
              onPressed: () => Navigator.pop(context, selected),
            ),
          ));
        },
      ),
    );
  }
}
