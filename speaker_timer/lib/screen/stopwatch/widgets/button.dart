import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onTap;
  final String type;

  Button({@required this.onTap, @required this.type});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Image.asset(
        type == 'play'? 'assets/play.png' : 
        type == 'pause'?'assets/pause.png' :
        'assets/reload.png'  ,
        fit: BoxFit.fill),
    );
  }
}