import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:self_comic/explorer.dart';

import 'package:self_comic/util.dart';
import 'package:self_comic/Reader/reader_page.dart';

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
          ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7),
              itemCount: comics.length,
              itemBuilder: (ctx, idx) {
                String path = comics[idx];
                return Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Ink.image(
                    image: FileImage(getCoverFile(path)),
                    child: InkWell(
                      highlightColor: Color(0x220099ff),
                      splashColor: Color(0x550099ff),
                      onTap: () => toRead(path),
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
                                onPressed: () {
                                  setState(() {
                                    prefs.setBool('ilf', ilf);
                                    Navigator.pop(context);
                                    deleteLocal(path).then((onValue) {
                                      comics = comics
                                        ..remove(path)
                                        ..where((ii) => ii != null).toList();
                                      prefs.setStringList('comics', comics);
                                    });
                                  });
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
