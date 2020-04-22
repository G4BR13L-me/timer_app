import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:speaker_timer/controller/status.dart';
import 'package:speaker_timer/controller/text_player.dart';
import 'package:speaker_timer/animations/expand_animation.dart';
import 'package:speaker_timer/screen/stopwatch/widgets/button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class StopWatch extends StatefulWidget {
  final PlayStatus player;

  StopWatch(this.player);
  @override
  _StopWatchNewState createState() => _StopWatchNewState();
}

class _StopWatchNewState extends State<StopWatch>
    with SingleTickerProviderStateMixin {
  final StopWatchTimer _stopWatchNewTimer = StopWatchTimer();

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    _animation = Tween<double>(begin: 0, end: 30).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack)
    );

    _animationController.forward();
  }

  @override
  void dispose() async {
    await _stopWatchNewTimer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  var time = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      //primary: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// Display stop watch time
          StreamBuilder(
              initialData: 0,
              stream: _stopWatchNewTimer.rawTime,
              builder: (context, snapshot) {
                return Text(
                  StopWatchTimer.getDisplayTime(snapshot.data),
                  style: TextStyle(color: Color(0xFFFFBD6B), fontSize: 45.0),
                );
              }),
          SizedBox(
            height: 20.0,
          ),

          /// Button
          Stack(
            children: <Widget>[
              Opacity(
                opacity: 0,
                child: SizedBox(height: 40,),
              ),
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _stopWatchNewTimer.isRunning()?
                    //Pause Button
                    ExpandAnimation(
                      fixWidth: true,
                        child: Button(
                            onTap: () async {
                              _pauseSetState(widget.player);
                            },
                            type: 'pause'),
                        animation: _animation)
                    : time == 0 ?
                        //Play Button
                        ExpandAnimation(
                            fixHeight: true,
                            child: Button(
                                onTap: () async {
                                  _playSetState(widget.player);
                                },
                                type: 'play'),
                            animation: _animation,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              //Play Button
                              ExpandAnimation(
                                fixHeight: true,
                                  child: Button(
                                      onTap: () async {
                                        _playSetState(widget.player);
                                      },
                                      type: 'play'),
                                  animation: _animation),

                              //Spacing the Widgets
                              SizedBox(
                                width: 45,
                              ),

                              //Reset Button
                              ExpandAnimation(
                                fixHeight: true,
                                  child: Button(
                                      onTap: () async {
                                        _resetSetState(widget.player);
                                      },
                                      type: 'reset'),
                                  animation: _animation),
                            ],
                          )
              ],
            ),
            ],
          ),
        ],
      ),
    );
  }

  void _playSetState(PlayStatus playStatus) {
    _animationController.reset();
    playStatus.isPlaying = true;
    playStatus.reset = false;
    _stopWatchNewTimer.onExecute.add(StopWatchExecute.start);
    _animationController.forward();
  }

  void _pauseSetState(PlayStatus playStatus) {
    _animationController.reset();
    playStatus.isPlaying = false;
    time = _stopWatchNewTimer.rawTime.value;
    _stopWatchNewTimer.onExecute.add(StopWatchExecute.stop);
    _animationController.forward();
  }

  void _resetSetState(PlayStatus playStatus) {
    _animationController.reset();
    time = 0;
    playStatus.isPlaying = false;
    playStatus.reset = true;
    _stopWatchNewTimer.onExecute.add(StopWatchExecute.reset);
    _animationController.forward();
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
