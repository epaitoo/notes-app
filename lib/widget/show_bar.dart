import 'package:flutter/material.dart';

class ShowBar extends StatelessWidget {
  const ShowBar({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40.0, bottom: 10.0), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 30.0,
              ), 
              onPressed: () {
                Navigator.pop(context);
              }
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 20.0)),
          Text(
             title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0
              ),
          ),
        ],
      ),
    );
  }
}