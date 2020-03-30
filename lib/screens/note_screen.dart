import 'dart:async';


import 'package:flutter/material.dart';
import 'package:notes/widgets/note_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/screens/note_detail.dart';
import 'package:notes/model/note.dart';
import 'package:notes/utils/database_helper.dart';

class NoteScreen extends StatefulWidget {
  @override
  NoteScreenState createState() => NoteScreenState();
}

class NoteScreenState extends State<NoteScreen> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   setState(() {
  //     updateListView();
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    // if (noteList == null) {
    //   noteList = List<Note>();
    //   updateListView();
    // }

    return Scaffold(
      backgroundColor: Color(0xffF9020E), 
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffF9020E),
        child: Icon(Icons.add),
        onPressed: () {
          // add code here
          navigateToDetail(Note('', '', ''), 'New Note');
          
        }
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 60.0, left:30.0, right:30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(
                    Icons.receipt,
                    size: 30.0,
                    color: Colors.black,
                  ),
                  backgroundColor: Color(0xfff9b73e),
                  radius: 30.0,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  // topRight: Radius.circular(20.0),
                ),
              ),
              child: NoteList(),
            ),
          ),
        ],
      )

    );
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title, note);
    })); 

    if (result == true) {
      updateListView();
    } 
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });

  }



}