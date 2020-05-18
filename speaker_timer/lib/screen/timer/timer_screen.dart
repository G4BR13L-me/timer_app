import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:speaker_timer/screen/background/background.dart';
import 'dart:math' as math;

import 'package:speaker_timer/screen/background/widgets/crystal.dart';

class Timer extends StatefulWidget {
  @override
  _TimerNewState createState() => _TimerNewState();
}

class _TimerNewState extends State<Timer> {
  bool selected = false;
  int millisecond;

  int dateTimeToMilliSecond(DateTime date){
    return date.second*1000 + date.minute*60000 + date.hour*1440000;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height:double.infinity,
      color: Color(0xFFEAE9EA),
      child: Stack(
        children: <Widget>[
          Center(
            child: Crystal(
              child: GestureDetector(
                onTap: (){
                  DatePicker.showTimePicker(context, showTitleActions: true,
                  onConfirm: (date) {
                    setState(() {
                      selected = true;
                      millisecond = dateTimeToMilliSecond(date);
                    });
                  }, currentTime: DateTime.now());
                },
                child: Icon(Icons.insert_invitation,color: Colors.grey.withOpacity(0.5),size: 150,),
              )
            )
          ),
          selected? Background(isTimer: true,duration: millisecond):
          IgnorePointer(child: Container(color: Colors.transparent)),
        ],
      ),
    );
  }
}
