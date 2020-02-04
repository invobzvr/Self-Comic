import 'package:flutter/material.dart';
import 'package:self_comic/comic.dart';
import 'package:self_comic/util.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        color: Colors.white,
      ),
      child: TextField(
        autofocus: true,
        cursorColor: Colors.blue,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search a comic ...',
          icon: Icon(Icons.search),
        ),
        style: TextStyle(fontSize: 15),
        onSubmitted: (str) {
          Navigator.pushNamed(context, 'SearchPage', arguments: str);
        },
      ),
      height: 36,
      padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool ready = false;
  List<ComicItem> result;

  @override
  Widget build(BuildContext context) {
    final String word = ModalRoute.of(context).settings.arguments;
    if (!ready)
      searchReq(word).then((onValue) {
        result = onValue;
        setState(() {
          ready = true;
        });
      });
    return Scaffold(
      appBar: AppBar(title: Text(word)),
      body: ready
          ? result.length > 0
              ? ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    ComicItem ci = result[index];
                    return ListTile(
                      title: Text(ci.name),
                      subtitle: Text(ci.author),
                      leading: Image.network(ci.cover),
                      onTap: () {
                        // Navigator.of(context).pop();
                        Navigator.pushNamed(context, 'DetailPage', arguments: ci);
                      },
                    );
                  },
                )
              : Center(child: Text('No result .'))
          : Center(child: CircularProgressIndicator()),
    );
  }
}
