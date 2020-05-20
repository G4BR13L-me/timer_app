import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:speaker_timer/screen/background/background.dart';

import 'package:speaker_timer/screen/background/widgets/crystal.dart';
import 'package:speaker_timer/screen/timer/widgets/blink.dart';

class Timer extends StatefulWidget {
  @override
  _TimerNewState createState() => _TimerNewState();
}

class _TimerNewState extends State<Timer> with AutomaticKeepAliveClientMixin<Timer> {
  bool selected = false;
  int millisecond;

  int dateTimeToMilliSecond(DateTime date){
    return date.second*1000 + date.minute*60000 + date.hour*1440000;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: double.infinity,
      height:double.infinity,
      color: Color(0xFFEAE9EA),
      child: Stack(
        children: <Widget>[
          selected? Container(color: Colors.transparent) 
          : Center(
            child: Crystal(
              child: GestureDetector(
                onTap: (){
                  DatePicker.showTimePicker(context, showTitleActions: true,
                  onConfirm: (date) {
                    setState(() {
                      selected = true;
                      millisecond = dateTimeToMilliSecond(date);
                    });
                  }, 
                  currentTime: DateTime.now(),
                  /*theme: DatePickerTheme(

                  )*/
                  );
                },
                child: Blink(
                  child: Center(
                    child: Text(
                    '00:00.00',
                    style: TextStyle(
                      color: Color(0xFFEAE9EA), 
                      fontSize: MediaQuery.of(context).size.width/8.8,
                      decoration: TextDecoration.none),),
                  ),
                )
              )
            )
          ),
          selected? Background(isTimer: true,duration: millisecond):
          IgnorePointer(child: Container(color: Colors.transparent)),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}