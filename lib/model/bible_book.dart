// Bible Books PODO (Plain Old Dart Object)

class Data {
  String id;
  String bibleId;
  String abbreviation;
  String name;
  String nameLong;

  Data({
    this.id,
    this.bibleId,
    this.abbreviation,
    this.name,
    this.nameLong,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      bibleId: json["bibleId"],
      abbreviation: json["abbreviation"],
      name: json["name"],
      nameLong: json["nameLong"],
    );
  }
}