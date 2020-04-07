//  Verse PODO
class Verses {
  String id;
  String orgId;
  String bookId;
  String chapterId;
  String bibleId;
  String reference;

  Verses({
    this.id,
    this.orgId,
    this.bookId,
    this.chapterId,
    this.bibleId,
    this.reference,
  });

  factory Verses.fromJson(Map<String, dynamic> json){
    return Verses(
      id: json["id"],
      orgId: json["orgId"],
      bookId: json["bookId"],
      bibleId: json["bibleId"],
      chapterId: json["chapterId"],
      reference: json["reference"]
    );
  }
}
