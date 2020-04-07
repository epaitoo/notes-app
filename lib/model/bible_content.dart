class BibleContent {
    ContentData contentData;
    Meta meta;

    BibleContent({
        this.contentData,
        this.meta,
    });

    factory BibleContent.fromJson(Map<String, dynamic> json) => BibleContent(
        contentData: ContentData.fromJson(json["data"]),
        meta: Meta.fromJson(json["meta"]),
    );

    // Map<String, dynamic> toJson() => {
    //     "data": contentData.toJson(),
    //     "meta": meta.toJson(),
    // };
}

class ContentData {
  String id;
  String orgId;
  String bookId;
  String chapterId;
  String bibleId;
  String reference;
  String content;
  String copyright;
  Next next;
  Next previous;

  ContentData({
    this.id,
    this.orgId,
    this.bookId,
    this.chapterId,
    this.bibleId,
    this.reference,
    this.content,
    this.copyright,
    this.next,
    this.previous,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      id: json["id"],
      orgId: json["orgId"],
      bookId: json["bookId"],
      chapterId: json["chapterId"],
      bibleId: json["bibleId"],
      reference: json["reference"],
      content: json["content"],
      copyright: json["copyright"],
      next: Next.fromJson(json["next"]),
      previous: Next.fromJson(json["previous"])
    );
  }
}


//  Next PODO
class Next {
    String id;
    String number;

    Next({
        this.id,
        this.number,
    });

    factory Next.fromJson(Map<String, dynamic> json) => Next(
        id: json["id"],
        number: json["number"],
    ); 
}




// Meta PODO
class Meta {
  String fums;
  String fumsId;
  String fumsJsInclude;
  String fumsJs;
  String fumsNoScript;

  Meta(
      {this.fums,
      this.fumsId,
      this.fumsJsInclude,
      this.fumsJs,
      this.fumsNoScript});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      fums : json['fums'],
      fumsId : json['fumsId'],
      fumsJsInclude : json['fumsJsInclude'],
      fumsJs : json['fumsJs'],
      fumsNoScript : json['fumsNoScript']
    );
    
  }
}