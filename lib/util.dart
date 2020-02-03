import 'package:http/http.dart' as http;
import 'package:self_comic/comic.dart';

Future<List<ComicItem>> searchReq(String word) async {
  String res = await http.read('https://www.manhuadui.com/search/?keywords=$word');
  return SearchParser(res).result;
}

Future<ComicInfo> detailReq(String url) async {
  String res = await http.read(url);
  return DetailParser(res).result;
}

class SearchParser {
  RegExp srReg = RegExp('<li class="list-comic"(.*?)</li>', dotAll: true);
  RegExp ciReg = RegExp('<img src="(.*?)".*?<a href="(.*?)" title="(.*?)">.*?<p class="auth">(.*?)</p>', dotAll: true);
  List<ComicItem> result = [];

  SearchParser(String res) {
    srReg.allMatches(res).forEach((match) {
      RegExpMatch rzt = ciReg.firstMatch(match.group(0));
      result.add(ComicItem(rzt.group(3), rzt.group(2), rzt.group(1), rzt.group(4)));
    });
  }
}

class DetailParser {
  RegExp descReg = RegExp('<p class="comic_deCon_d">(.*?)</p>', dotAll: true);
  RegExp cptReg = RegExp('<a href="(.*?)" title="(.*?)" target="_blank">');
  ComicInfo result;

  DetailParser(String res) {
    result = ComicInfo(descReg.firstMatch(res).group(1));
    cptReg.allMatches(res).forEach((match) {
      result.cptLst.add(ChapterItem(match.group(2), match.group(1)));
    });
  }
}
