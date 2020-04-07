import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/model/chapter_list.dart';
import 'package:notes/model/bible_book.dart';
import 'package:notes/screens/chapter_content.dart';
import 'package:notes/widget/show_bar.dart';

class ChapterList extends StatefulWidget {

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {


  var chapters;


  @override
  Widget build(BuildContext context) {

    final Data bibleBooks = ModalRoute.of(context).settings.arguments;

    var bookId = bibleBooks.id;
    var bookName = bibleBooks.name;

    Future<List<Chapters>> getChapters() async {
      List<Chapters> chaptersList;
      String url = 'https://api.scripture.api.bible/v1/bibles/de4e12af7f28f599-01/books/$bookId/chapters';

      final response = await http.get(url, headers: {'api-key': '7d076034f25e7b8256cec170c136caca', 'Accept': 'application/json'});

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var rest = data['data'] as List;

        chaptersList = rest.map<Chapters>((json) => Chapters.fromJson(json)).toList();

        chapters = chaptersList;

      }else {
        throw Exception('Failed to load post');
      }

      return chaptersList;

    }

    return Scaffold(
      backgroundColor: Color(0xffF9020E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ShowBar(title: bookName),
          Expanded(
            child: Container(
              height: 300.0,
              child: FutureBuilder<List<Chapters>>(
                future: getChapters(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: GridView.count(
                        crossAxisCount: 7, 
                        crossAxisSpacing: 10.0, 
                        mainAxisSpacing: 1.0,

                        children: List.generate(chapters.length, (index) {
                          return InkWell(
                            splashColor: Colors.yellow,
                            highlightColor: Colors.blue.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                chapters[index].number,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowChapterContent(),
                                  settings: RouteSettings(
                                    arguments: chapters[index],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    );

                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                  // By default, show a loading spinner.
                  return Center(child: CircularProgressIndicator());
                }
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ],
      ),
      
    );
  }
}