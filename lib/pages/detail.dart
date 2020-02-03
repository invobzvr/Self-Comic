import 'package:flutter/material.dart';
import 'package:self_comic/comic.dart';
import 'package:self_comic/util.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool ready = false;
  ComicInfo result;
  List<Tree> treeData;

  @override
  Widget build(BuildContext context) {
    final ComicItem ci = ModalRoute.of(context).settings.arguments;
    detailReq(ci.url).then((onValue) {
      result = onValue;
      // treeData = arrange(result.cptLst);
      setState(() {
        ready = true;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(ci.name),
        actions: [
          IconButton(
            icon: Icon(Icons.import_export),
            onPressed: () {
              setState(() {
                result.cptLst = result.cptLst.reversed.toList();
              });
            },
          )
        ],
        bottom: ready
            ? PreferredSize(
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Image.network(ci.cover, width: 200),
                      ),
                      Flexible(
                        child: Text(
                          result.desc.trim(),
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                preferredSize: Size(150, 300),
              )
            : null,
      ),
      body: ready
          // ? ExpansionPanelList(
          //     animationDuration: Duration(milliseconds: 500),
          //     expansionCallback: (index, isExpanded) {
          //       setState(() {
          //         treeData[index].isExpanded = !isExpanded;
          //       });
          //     },
          //     children: treeData.map((tree) {
          //       return ExpansionPanel(
          //           headerBuilder: (context, isExpanded) => ListTile(title: Text(tree.ttl)),
          //           body: Container(
          //             height: 200,
          //             child: ListView.builder(
          //               itemCount: tree.lst.length,
          //               itemBuilder: (context, index) {
          //                 return ListTile(
          //                   title: Text(tree.lst[index].name),
          //                   onTap: () {},
          //                 );
          //               },
          //             ),
          //           ),
          //           isExpanded: tree.isExpanded);
          //     }).toList(),
          //   )
          ? ListView(
              children: result.cptLst.map((cpt) {
                return ListTile(
                  title: Text(cpt.name),
                  onTap: () {
                    Navigator.pushNamed(context, 'ReaderPage', arguments: cpt.url);
                  },
                );
              }).toList(),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  List<Tree> arrange(List<ChapterItem> cptLst) {
    List<Tree> treeData = [];
    Tree tree;
    for (int i = 0; i < cptLst.length; i++) {
      if ((i % 50 == 0 && i > 0) || i == cptLst.length - 1) {
        treeData.add(tree);
      }
      if (i % 50 == 0) {
        tree = Tree('${i + 1} - ${i + 50}');
      }
      tree.lst.add(cptLst[i]);
    }
    return treeData;
  }
}

class Tree {
  Tree(this.ttl);

  String ttl;
  List<ChapterItem> lst = [];
  bool isExpanded = false;
}
