import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Time extends StatelessWidget {

  final StopWatchTimer stopWatchTimer;

  Time({@required this.stopWatchTimer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: StreamBuilder<int>(
        stream: stopWatchTimer.rawTime,
        initialData: stopWatchTimer.rawTime.value,
        builder: (context, snap) {
          final value = snap.data;
          final displayTime = StopWatchTimer.getDisplayTime(value);
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  displayTime,
                  style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  value.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
