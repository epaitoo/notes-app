import 'package:flutter/material.dart';
import 'package:notes/model/chapter_list.dart';
import 'package:notes/model/verse_list.dart';
import 'package:notes/screens/bible_passage.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/widget/show_bar.dart';

class VerseList extends StatefulWidget {
  @override
  _VerseListState createState() => _VerseListState();
}

class _VerseListState extends State<VerseList> {

  var verses;
  int verseValue;

  


  @override
  Widget build(BuildContext context) {

    final Chapters chapters = ModalRoute.of(context).settings.arguments;

    var chapterId = chapters.id;
    // var chapterNumber = chapters.number;
    var chapterReference = chapters.reference;

     Future<List<Verses>> getVerses() async {
      List<Verses> verseList;

      String url = 'https://api.scripture.api.bible/v1/bibles/de4e12af7f28f599-01/chapters/$chapterId/verses';

      final response = await http.get(url, headers: {'api-key': '7d076034f25e7b8256cec170c136caca', 'Accept': 'application/json'});

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var rest = data['data'] as List;

        verseList = rest.map<Verses>((json) => Verses.fromJson(json)).toList();

        verses = verseList;
      } else {
        throw Exception('Failed to load post');
      }

      return verseList;

    }


    return Scaffold(
      backgroundColor: Color(0xffF9020E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ShowBar(title: chapterReference),
          Expanded(
            child:  Container(
              height: 300.0,
              child: FutureBuilder<List<Verses>>(
                future: getVerses(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      child: GridView.count(
                        crossAxisCount: 7, 
                        crossAxisSpacing: 10.0, 
                        mainAxisSpacing: 1.0,

                        children: List.generate(verses.length, (index) {
                          verseValue = index + 1;
                          return InkWell(
                            splashColor: Colors.yellow,
                            highlightColor: Colors.blue.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                verseValue.toString(),
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowBiblePassage(),
                                  settings: RouteSettings(
                                    arguments: verses[index],
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
                },
                
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
      )
      
    );
  }
}