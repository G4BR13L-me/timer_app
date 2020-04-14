import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width*1.0/4.0,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Icon(Icons.home),
          ),
          GestureDetector(
            child: Icon(Icons.home),
          ),
          GestureDetector(
            child: Icon(Icons.home),
          ),
          GestureDetector(
            child: Icon(Icons.home),
          ),
        ],
      ),
    );
  }
}