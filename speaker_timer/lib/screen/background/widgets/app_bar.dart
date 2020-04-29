import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width/6.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
        color: Color(0xFFEAE9EA),
        boxShadow: [BoxShadow(
          color: Colors.black54,
        )]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              child: Image.asset('assets/hourglass_icon.png',fit: BoxFit.fill,),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: GestureDetector(
              child: Icon(Icons.timer),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: GestureDetector(
              child: Icon(Icons.alarm),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: GestureDetector(
              child: Icon(Icons.hourglass_empty),
            ),
          ),
        ],
      ),
    );
  }
}