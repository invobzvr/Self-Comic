import 'package:flutter/material.dart';

import 'package:self_comic/util.dart';

class ReaderPage extends StatefulWidget {
  final String path;

  ReaderPage(this.path);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    PageController pageController = PageController();
    var files = loadDir(widget.path);
    return GestureDetector(
      child: PageView.builder(
        controller: pageController,
        itemCount: files.length,
        itemBuilder: (ctx, idx) => Image.file(files[idx]),
      ),
      onTapUp: (dtl) {
        if (dtl.localPosition.dx < width / 5) {
          pageController.previousPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        } else if (dtl.localPosition.dx > width / 5 * 4) {
          pageController.nextPage(duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        }
      },
    );
  }
}
