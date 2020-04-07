import 'package:flutter/material.dart';
import 'package:notes/model/bible_book.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes/screens/chapter_list.dart';
import 'package:notes/widget/show_bar.dart';


class BibleBooks extends StatefulWidget {
  @override
  _BibleBooksState createState() => _BibleBooksState();
}

class _BibleBooksState extends State<BibleBooks> {

  String mySelection;
  var bibleBooks;

  Future<List<Data>> getBooks() async {
    List<Data> list;
    String url = 'https://api.scripture.api.bible/v1/bibles/de4e12af7f28f599-01/books';

    final response = await http.get(url, headers: {'api-key': '7d076034f25e7b8256cec170c136caca', 'Accept': 'application/json'});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data['data'] as List;

      // print(rest);

      list = rest.map<Data>((json) => Data.fromJson(json)).toList();
      bibleBooks = list;
    } else {
      throw Exception('Failed to load post');
    }

    return list;

  }

  @override
  void initState() { 
    super.initState();
    setState(() {
      getBooks();
    });  
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF9020E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ShowBar(title: 'Choose Book'),         
          Expanded(
            child: Container(
              height: 300.0,
              child: FutureBuilder<List<Data>>(
                future: getBooks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                       itemCount: bibleBooks.length,
                        itemBuilder: (context, position) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                '${bibleBooks[position].name}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChapterList(),
                                    settings: RouteSettings(
                                      arguments: bibleBooks[position],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
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