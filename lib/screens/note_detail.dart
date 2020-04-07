// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes/screens/bible_books.dart';
import 'package:notes/utils/database_helper.dart';
import 'package:notes/model/note.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget {

  final String appBarTitle;
	final Note note;

  NoteDetail(this.appBarTitle, this.note);

  @override
  NoteDetailState createState() => NoteDetailState(this.note, this.appBarTitle);
}

class NoteDetailState extends State<NoteDetail> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleTextController = TextEditingController();
  TextEditingController contentTextController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  void updateTitle() {
    note.title =  titleTextController.text;
  }

  void updateContent(){
    note.content = contentTextController.text;
  }

  
  

  @override
  Widget build(BuildContext context) {
    
    titleTextController.text = note.title;
    contentTextController.text = note.content;

    return Scaffold(
      backgroundColor: Color(0xffF9020E),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffF9020E),
        child: Icon(Icons.import_contacts),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BibleBooks()),
          );
        }
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 40.0, bottom: 10.0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 40.0,
                    ), 
                    onPressed: () {
                      Navigator.pop(context, true);
                    }
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 30.0)),
                Expanded(
                  child: Center(
                    child: Text(
                      appBarTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30.0)),
                Expanded(
                  child: IconButton(
                    icon: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    onPressed: () {
                      setState(() {
                        _save();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 300.0,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextField(
                      controller: titleTextController,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 22.0
                      ),
                      onChanged: (value) {
                        updateTitle();
                      },
                      maxLines: 2,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "Title",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0,  right: 15.0, bottom: 10.0),
                    child: TextField(
                      controller: contentTextController,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0
                      ),
                      onChanged: (value) {
                        updateContent();
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                        hintText: "Content",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 20.0
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
            ),
          ),
        ],
      )
      
    );
  }

  void _save() async {

    Navigator.pop(context, true);

    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;

    if (note.id != null) {  // Case 1: Update operation
			result = await helper.updateNote(note);
		} else { // Case 2: Insert Operation
			result = await helper.insertNote(note);
		}

    if (result != 0) {  // Success
			_showAlertDialog('Status', 'Note Added Successfully.');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Saving Note');
		}

  }

  void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}





}