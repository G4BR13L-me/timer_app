import 'package:flutter/material.dart';

class TimeText extends StatelessWidget {
  final String text;

  TimeText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).backgroundColor, 
        fontSize: MediaQuery.of(context).size.width/8.8,
        decoration: TextDecoration.none)
    );
  }
}