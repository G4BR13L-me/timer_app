import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speaker_timer/screen/app_pageview.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //|| COLORS: 
  //||  - 6BB8FF -- rgb(107,184,255) 
  //||
  //||  - B66BFF -- rgb(182,107,255)
  //||    A360E6 -- rgb(163,96,230)
  //||    8850BF -- rgb(136,80,191)
  //||
  //||  - FFF75E -- rgb(255,247,94)
  //||  - FFBD6B -- rgb(255,189,107)
  //||
  //||  - FF6B6B -- rgb(255,107,107)

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFF4F6F5),
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF4F6F5),
      systemNavigationBarIconBrightness: Brightness.dark

    ));
    return MaterialApp(
      home: AudioServiceWidget(child: AppPageView()),
      theme: ThemeData(
        backgroundColor: Color(0xFFF4F6F5),
        primaryColor: Color(0xFFE1BF92),
        accentColor: Color(0xFFB53B51),
        hintColor: Color(0xFF465E8A),//39538A - 465E8A
        buttonColor: Color(0xFF7A8588)
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}