import 'dart:isolate';
import 'dart:ui';
//import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:speaker_timer/controller/text_player.dart';

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Teste'), centerTitle: true),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              width: 25.0,
              height: 25.0,
              child: CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation(Colors.yellow),
                  value: 0.5),
            ),
            IconButton(
              icon: Icon(Icons.play_circle_outline),
              onPressed: () async {
                //  await AndroidAlarmManager.oneShotAt(DateTime(year), Random().nextInt(pow(2, 31)), callback);
                /*  .oneShot(
                  const Duration(seconds: 5),
                  // Ensure we have a unique alarm ID.
                  Random().nextInt(pow(2, 31)),
                  callback,
                  exact: true,
                  wakeup: true,
                );*/
              },
            )
          ],
        ));
  }

  RaisedButton textToSpeechButton() => startButton(
        'TextToSpeech',
        () {
          AudioService.start(
            backgroundTaskEntrypoint: _textToSpeechTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            notificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
          );
        },
      );

  RaisedButton startButton(String label, VoidCallback onPressed) =>
      RaisedButton(
        child: Text(label),
        onPressed: onPressed,
      );

  static SendPort uiSendPort;

  // The callback for our alarm
  static Future<void> callback() async {
    print('Alarm fired!');
    // This will be null if we're running in the background.
    uiSendPort ??= IsolateNameServer.lookupPortByName('isolate');
    uiSendPort?.send(null);
  }
}

void _textToSpeechTaskEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayerTask('Alarm'));
}