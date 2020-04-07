// CHAPTER CONTENT
class ChapterContent {
    ChapterData chapterData;
    ChapterMeta chapterMeta;

    ChapterContent({
        this.chapterData,
        this.chapterMeta,
    });

    factory ChapterContent.fromJson(Map<String, dynamic> json) => ChapterContent(
        chapterData: ChapterData.fromJson(json["data"]),
        chapterMeta: ChapterMeta.fromJson(json["meta"]),
    );
}


class ChapterData {
  String id;
  String bibleId;
  String number;
  String bookId;
  String reference;
  String copyright;
  String content;
  NextChapter next;
  NextChapter previous;

  ChapterData({
    this.id,
    this.bibleId,
    this.number,
    this.bookId,
    this.reference,
    this.copyright,
    this.content,
    this.next,
    this.previous,
  });

  factory ChapterData.fromJson(Map<String, dynamic> json) {
    return ChapterData(
      id: json["id"],
      bibleId: json["bibleId"],
      number: json["number"],
      bookId: json["bookId"],
      reference: json["reference"],
      copyright: json["copyright"],
      content: json["content"],
      next: NextChapter.fromJson(json["next"]),
      previous: NextChapter.fromJson(json["previous"]),
    );
  }
}


class NextChapter {
    String id;
    String number;

    NextChapter({
        this.id,
        this.number,
    });

    factory NextChapter.fromJson(Map<String, dynamic> json) => NextChapter(
        id: json["id"],
        number: json["number"],
    ); 
}


class ChapterMeta {
  String fums;
  String fumsId;
  String fumsJsInclude;
  String fumsJs;
  String fumsNoScript;

  ChapterMeta(
      {this.fums,
      this.fumsId,
      this.fumsJsInclude,
      this.fumsJs,
      this.fumsNoScript});

  factory ChapterMeta.fromJson(Map<String, dynamic> json) {
    return ChapterMeta(
      fums : json['fums'],
      fumsId : json['fumsId'],
      fumsJsInclude : json['fumsJsInclude'],
      fumsJs : json['fumsJs'],
      fumsNoScript : json['fumsNoScript']
    );
    
  }
}