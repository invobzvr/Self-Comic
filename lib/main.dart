import 'package:flutter/material.dart';
import 'package:self_comic/pages/search.dart';
import 'package:self_comic/pages/detail.dart';
import 'package:self_comic/pages/reader.dart';

const NAME = 'Self Comic';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: NAME,
      theme: ThemeData(primaryColor: Colors.blue),
      home: SCHome(),
      routes: {
        'SearchPage': (context) => SearchPage(),
        'DetailPage': (context) => DetailPage(),
        'ReaderPage': (context) => ReaderPage(),
      },
    );
  }
}

class SCHome extends StatefulWidget {
  @override
  _SCHomeState createState() => _SCHomeState();
}

class _SCHomeState extends State<SCHome> {
  bool searching = false;
  Widget title = Text(NAME);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searching ? SearchField() : title,
        actions: [
          IconButton(
            icon: Icon(searching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                searching = !searching;
              });
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          'Welcome',
          style: TextStyle(fontSize: 36),
        ),
      ),
    );
  }
}
