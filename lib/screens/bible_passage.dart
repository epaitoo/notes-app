import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/model/verse_list.dart';
import 'package:notes/model/bible_content.dart';
import 'package:notes/widget/show_bar.dart';


class ShowBiblePassage extends StatefulWidget {
  @override
  _ShowBiblePassageState createState() => _ShowBiblePassageState();
}

class _ShowBiblePassageState extends State<ShowBiblePassage> {


  var passage;


  @override
  Widget build(BuildContext context) {

    final Verses verse = ModalRoute.of(context).settings.arguments;

    var verseId = verse.id;
    var verseTitle = verse.reference;
    // print(verseId);

    //  REfactor this to a function
    Future getContent() async {

      var queryParameters = {
        'content-type': 'text',
      };

      var uri = Uri.https('api.scripture.api.bible', 'v1/bibles/de4e12af7f28f599-01/verses/$verseId', queryParameters);

      // String url = 'https://api.scripture.api.bible/v1/bibles/bibleId/verses/verseId';
      
      final response = await http.get(uri, headers: {'api-key': '7d076034f25e7b8256cec170c136caca', 'Accept': 'application/json'});

      var biblePassage;
      // var reference;

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        BibleContent bibleContent = BibleContent.fromJson(data);
        biblePassage = bibleContent.contentData;
        // reference = bibleContent.contentData.reference;
        passage = biblePassage;
        // print(bibleContent.contentData.content);
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
          ShowBar(title: verseTitle),
          Expanded(
            child: Container(
              height: 300.0,
              child:  FutureBuilder(
                future: getContent(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(passage.content, style: TextStyle(fontSize: 20.0),),
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

      ),
    );
  }
}