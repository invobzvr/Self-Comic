class ComicItem {
  ComicItem(this.name, this.url, this.cover, this.author);

  String name;
  String url;
  String cover;
  String author;
}

class ChapterItem {
  ChapterItem(this.name, this.url);

  String name;
  String url;
}

class ComicInfo {
  ComicInfo(this.desc);

  String desc;
  List<ChapterItem> cptLst = [];
}
