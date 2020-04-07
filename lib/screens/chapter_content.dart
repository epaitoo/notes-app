import 'package:flutter/material.dart';
import 'package:notes/model/chapter_content.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/model/chapter_list.dart';
import 'package:notes/screens/verse_list.dart';
import 'package:notes/widget/show_bar.dart';

class ShowChapterContent extends StatefulWidget {
  @override
  _ShowChapterContentState createState() => _ShowChapterContentState();
}

class _ShowChapterContentState extends State<ShowChapterContent> {

  var passage;

  @override
  Widget build(BuildContext context) {

    final Chapters chapters = ModalRoute.of(context).settings.arguments;
    
    var chapterId = chapters.id;
    var chapterReference = chapters.reference;

     Future getChapterContent() async {
      var queryParameters = {
        'content-type': 'text',
      };

      var uri = Uri.https('api.scripture.api.bible', 'v1/bibles/de4e12af7f28f599-01/chapters/$chapterId', queryParameters);

      
      final response = await http.get(uri, headers: {'api-key': '7d076034f25e7b8256cec170c136caca', 'Accept': 'application/json'});

      var biblePassage;

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        ChapterContent chapterContent = ChapterContent.fromJson(data);
        biblePassage = chapterContent.chapterData.content;
        passage = biblePassage;
      } else {
        throw Exception('Failed to load post');
      }

      return biblePassage;
    }


    return Scaffold(
      backgroundColor: Color(0xffF9020E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ShowBar(title: chapterReference),
          Expanded(
            child: Container(
              height: 300.0,
              child:  FutureBuilder(
                future: getChapterContent(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerseList(),
                                  settings: RouteSettings(
                                    arguments: chapters,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Select a Verse',
                              style: TextStyle(fontSize: 20, color: Colors.white)
                            ),
                            color: Colors.green,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: SingleChildScrollView(
                                child: Text(passage, style: TextStyle(fontSize: 20.0),)
                              ),
                            ),
                          ),
                        ),
                      ],
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
            )
          ),
        ],


      ),
      
    );
  }
}

