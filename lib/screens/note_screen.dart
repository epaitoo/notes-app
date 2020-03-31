import 'dart:async';


import 'package:flutter/material.dart';
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
  bool hasNotes = false;


  @override
  void initState() {
    super.initState(); 
    updateListView();

  }

  // Navigate a specific Note
  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(title, note);
    })); 

    if (result == true) {
      updateListView();
    } 
  }

  // Update the Note List
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

  // Text to show when noteslist is Empty 
  Widget showNoDataText() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Tap on + to add new note',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            
          ),
        ),
      ),
    );
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
              child: count == 0 ? showNoDataText() : getNoteList(),
            ),
          ),
        ],
      )

    );
  }

  ListView getNoteList() {
    return ListView.builder(
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
      });
  }

}