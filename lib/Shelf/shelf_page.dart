import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:self_comic/explorer.dart';
import 'package:self_comic/Reader/reader_page.dart';

File getCoverFile(String path) {
  return loadDir(path).first;
}

class ShelfPage extends StatefulWidget {
  @override
  _ShelfPageState createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  bool ready = false;
  List<String> comics;
  SharedPreferences prefs;

  void toRead(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReaderPage(path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      SharedPreferences.getInstance().then((onValue) => setState(() {
            comics = (prefs = onValue).getStringList('comics') ?? [];
            ready = true;
          }));
    }
    return Scaffold(
      appBar: AppBar(title: Text('Shelf')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Explorer.show(context).then((path) {
            if (path == null) return;
            if (loadDir(path).length == 0) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(content: Text('No images .')),
              );
              return;
            }
            toRead(path);
            if (!comics.contains(path)) {
              setState(() => comics.add(path));
              prefs.setStringList('comics', comics);
            }
          });
        },
      ),
      body: ready
          ? ListView.separated(
              itemCount: comics.length,
              separatorBuilder: (ctx, idx) => Divider(),
              itemBuilder: (ctx, idx) {
                String path = comics.elementAt(idx);
                return Dismissible(
                  key: Key(path),
                  direction: DismissDirection.endToStart,
                  child: ListTile(
                    leading: Image.file(getCoverFile(path), width: 100),
                    title: Text(path.split('/').last),
                    onTap: () => toRead(path),
                  ),
                  onDismissed: (direction) => setState(() {
                    comics = comics
                      ..remove(path)
                      ..where((ii) => ii != null).toList();
                  }),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
