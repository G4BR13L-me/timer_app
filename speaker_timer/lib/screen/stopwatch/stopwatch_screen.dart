import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:speaker_timer/controller/text_player.dart';
import 'package:speaker_timer/animations/expand_animation.dart';
import 'package:speaker_timer/screen/stopwatch/widgets/button.dart';
import 'package:speaker_timer/screen/stopwatch/widgets/show_time.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatch extends StatefulWidget {
  @override
  _StopWatchState createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch>
    with SingleTickerProviderStateMixin {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  AnimationController _animationController;
  Animation<double> _animation;

  //final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = Tween<double>(begin: 0, end: 30).animate(_animationController);

    _animationController.forward();

    //_stopWatchTimer.records.listen((value) => print('records $value'));
  }

  @override
  void dispose() async {
    await _stopWatchTimer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  var time = 0;
  var pause = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      primary: false,
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// Display stop watch time
          Time(stopWatchTimer: _stopWatchTimer),
          /*
              /// Lap time.
              Container(
                height: 120,
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    if (value.isEmpty) {
                      return Container();
                    }
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    });
                    print('Listen records. $value');
                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final data = value[index];
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${index + 1} ${data.displayTime}',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 1,
                            )
                          ],
                        );
                      },
                      itemCount: value.length,
                    );
                  },
                ),
              ),
              */
          /// Button
          Padding(
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _stopWatchTimer.isRunning()
                    ?
                    //Pause Button
                    ExpandAnimation(
                        child: Button(
                            onTap: () async {
                              _pauseSetState();
                            },
                            type: 'pause'),
                        animation: _animation)
                    : time == 0
                        ?
                        //Play Button
                        ExpandAnimation(
                            child: Button(
                                onTap: () async {
                                  _playSetState();
                                },
                                type: 'play'),
                            animation: _animation,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //Play Button
                              ExpandAnimation(
                                  child: Button(
                                      onTap: () async {
                                        _playSetState();
                                      },
                                      type: 'play'),
                                  animation: _animation),

                              //Spacing the Widgets
                              SizedBox(
                                width: 25,
                              ),

                              //Reset Button
                              ExpandAnimation(
                                  child: Button(
                                      onTap: () async {
                                        _resetSetState();
                                      },
                                      type: 'reset'),
                                  animation: _animation),
                            ],
                          )
                /*Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: RaisedButton(
                                      padding: const EdgeInsets.all(4),
                                      color: Colors.deepPurpleAccent,
                                      shape: const StadiumBorder(),
                                      onPressed: () async {
                                        _stopWatchTimer.onExecute
                                            .add(StopWatchExecute.lap);
                                      },
                                      child: Text(
                                        'Lap',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _playSetState() {
    setState(() {
      _animationController.reset();
      pause = false;
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      _animationController.forward();
    });
  }

  void _pauseSetState() {
    setState(() {
      _animationController.reset();
      pause = true;
      time = _stopWatchTimer.rawTime.value;
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      _animationController.forward();
    });
  }

  void _resetSetState() {
    setState(() {
      _animationController.reset();
      time = 0;
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      _animationController.forward();
    });
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
}

void _textToSpeechTaskEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayerTask(10));
}
