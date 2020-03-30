import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notes/model/note.dart';
import 'package:notes/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes/screens/note_detail.dart';


class NoteList extends StatefulWidget {
  @override
  NoteListState createState() => NoteListState();
}

class NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() { 
    super.initState();
    refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      updateListView();
    });
    return null;

  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  

  @override
  Widget build(BuildContext context) {

    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }





    return RefreshIndicator(
          child: ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:  <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Text(getFirstLetter(this.noteList[index].title),
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                    title: Text(
                      this.noteList[index].title,
                      style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(this.noteList[index].date),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          child: Icon(Icons.delete,color: Colors.grey,),
                          onTap: () {
                            _delete(context, noteList[index]);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // debugPrint("ListTile Tapped");
                      navigateToDetail(this.noteList[index], 'Edit Note');
                    }
                  ),
                ],
              ),


            );
          }
      ),
      onRefresh: refreshList,
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