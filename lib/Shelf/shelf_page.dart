import 'dart:io';
import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:explorer/explorer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:self_comic/Reader/reader_page.dart';

class ShelfPage extends StatefulWidget {
  @override
  _ShelfPageState createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> with AutomaticKeepAliveClientMixin {
  bool ready = false;
  List<String> comics;
  SharedPreferences prefs;

  @override
  bool get wantKeepAlive => true;

  void toRead(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReaderPage(path)),
    );
  }

  bool checkComic(String ii) {
    return !comics.contains(ii) && Explorer.list<File>(ii).where((ii) => ii.path.endsWith('.jpg') || ii.path.endsWith('.png')).length > 0;
  }

  void addComic(Iterable<String> paths) {
    setState(() => comics.addAll(paths));
    prefs.setStringList('comics', comics);
  }

  void removeComic(String path, [bool ilf = false]) {
    comics = comics
      ..remove(path)
      ..where((ii) => ii != null).toList();
    prefs.setStringList('comics', comics);
    if (ilf) {
      Directory(path).delete(recursive: true);
    }
  }

  void acAdapter(String path) {
    if (path == null) return;
    Map<String, bool> dirs = {for (var ii in Explorer.listNames<Directory>(path)) if (checkComic('$path/$ii')) ii: true};
    Size size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text('Select Comics'),
          content: Container(
            width: size.width,
            height: size.height,
            child: ListView.builder(
              itemCount: dirs.length,
              itemBuilder: (ctx, idx) {
                var ii = dirs.entries.elementAt(idx);
                return CheckboxListTile(
                  title: Text(ii.key),
                  value: ii.value,
                  onChanged: (val) => setState(() => dirs[ii.key] = val),
                );
              },
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: Text('Reverse'),
              onPressed: () => setState(() => {for (var ii in dirs.entries) dirs[ii.key] = !ii.value}),
            ),
            FlatButton(
              child: Text('Select'),
              onPressed: dirs.length > 0
                  ? () => setState(() {
                        Navigator.pop(context);
                        List<String> lst = [for (var ii in dirs.entries) if (ii.value) '$path/${ii.key}'];
                        if (lst.length > 0) addComic(lst);
                      })
                  : null,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
        onPressed: () => Explorer.show(context).then(acAdapter),
      ),
      body: ready
          ? StaggeredGridView.countBuilder(
              crossAxisCount: 3,
              staggeredTileBuilder: (idx) => StaggeredTile.fit(1),
              itemCount: comics.length,
              itemBuilder: (ctx, idx) {
                String path = comics[idx];
                return Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    child: CupertinoButton(
                      pressedOpacity: 0.6,
                      padding: EdgeInsets.all(0),
                      child: Image.file(Explorer.list(path).first),
                      onPressed: () => toRead(path),
                    ),
                    splashColor: Color(0xff0099ff),
                    onLongPress: () {
                      bool ilf = prefs.getBool('ilf') ?? false;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete ?'),
                          content: StatefulBuilder(
                            builder: (ctx, setState) => CheckboxListTile(
                              title: Text('include local files'),
                              value: ilf,
                              onChanged: (val) => setState(() => ilf = val),
                            ),
                          ),
                          actions: [
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context),
                            ),
                            FlatButton(
                              child: Text('Confirm'),
                              onPressed: () => setState(() {
                                Navigator.pop(context);
                                prefs.setBool('ilf', ilf);
                                removeComic(path, ilf);
                              }),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
