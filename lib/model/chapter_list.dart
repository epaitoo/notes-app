// Bible Book Chapter PODO
class Chapters {
  String id;
  String bibleId;
  String bookId;
  String number;
  String reference;

  Chapters({
    this.id,
    this.bibleId,
    this.bookId,
    this.number,
    this.reference,
  });

  factory Chapters.fromJson(Map<String, dynamic> json) {
    return Chapters(
      id: json["id"],
      bibleId: json["bibleId"],
      bookId: json["bookId"],
      number: json["number"],
      reference: json["reference"],
    );
  }
}
