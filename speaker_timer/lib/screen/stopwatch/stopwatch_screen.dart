import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:speaker_timer/controller/status.dart';
import 'package:speaker_timer/animations/expand_animation.dart';
import 'package:speaker_timer/controller/text_player.dart';
import 'package:speaker_timer/screen/stopwatch/widgets/button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:vibration/vibration.dart';

class StopWatch extends StatefulWidget{
  final PlayStatus player;
  final int duration;
  final bool isTimer;

  StopWatch(this.player,this.duration,this.isTimer);

  static String getDisplayHour(int value) {
    final m = (value / 1440000).floor();
    return m.toString().padLeft(2, '0');
  }

  static String getDisplayTimeMinute(int value) {
    final m = (value / 60000).floor();
    return m.toString().padLeft(2, '0');
  }

  static int getDisplayTimeSecond(int value) {
    return (value % 60000 / 1000).floor();
  }
  
  // Display Time for The Timer mode [hour : minute : second]
  static String getDisplayTime(int value){
    String second = StopWatchTimer.getDisplayTimeSecond(value);
    String hour = getDisplayHour(value);
    value -= int.parse(hour)*1440000;
    String minute = getDisplayTimeMinute(value);
    String result = '';

    result += '$hour';
    result += ':';
    result += '$minute';
    result += ':';
    result += '$second';
    return result;
  }

  @override
  _StopWatchNewState createState() => _StopWatchNewState();
}

void _textToSpeechTaskEntrypoint() async {
  AudioServiceBackground.run(() => TextPlayerTask());
}

class _StopWatchNewState extends State<StopWatch>
    with SingleTickerProviderStateMixin {
  final StopWatchTimer _stopWatch = StopWatchTimer();
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _stopWatch.rawTime.listen((value) => AudioService.customAction("setTime", value));

    AudioService.customEventStream.listen((event) {
      switch (event) {
        case 'playing':
          _playSetState(widget.player);
          break;
        case 'pause':
          _pauseSetState(widget.player);
          break;
        case 'stop':
          _resetSetState(widget.player);
          break;
        default:
      }
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    _animation = Tween<double>(begin: 0, end: 30).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatch.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /// Display stop watch time
          StreamBuilder<int>(
              initialData: 0,
              stream: _stopWatch.rawTime,
              builder: (context, snapshot) {
                if(widget.isTimer){
                  // Vibrate when the Timer ends
                  if(widget.duration - snapshot.data==0)
                    Vibration.vibrate(pattern: [150, 150, 100],intensities: [100,0,75]);
                }else{
                  // Vibrate every time the time is multiple of the widget.duration parameter
                  if(snapshot.data%widget.duration==0&&snapshot.data!=0)
                    Vibration.vibrate(pattern: [150, 150, 100],intensities: [100,0,75]);
                }
                return Text(
                  widget.isTimer 
                  ? StopWatch.getDisplayTime(widget.duration - snapshot.data)
                  : StopWatchTimer.getDisplayTime(snapshot.data),
                  style: TextStyle(color: Theme.of(context).backgroundColor, fontSize: 45.0),
                );
              }),
          SizedBox(
            height: 20.0,
          ),

          /// BUTTONS
          Stack(
            children: <Widget>[
              Opacity(
                opacity: 0,
                child: SizedBox(
                  height: 40,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.player.isPlaying
                      ?
                      //Pause Button
                      ExpandAnimation(
                          fixWidth: true,
                          child: Button(
                              onTap: () {
                                AudioService.pause();
                                _pauseSetState(widget.player);
                              },
                              type: 'pause'),
                          animation: _animation)
                      : widget.player.reset
                          ?
                          //Play Button
                          ExpandAnimation(
                              fixHeight: true,
                              child: Button(
                                  onTap: () async {
                                    await AudioService.start(
                                      backgroundTaskEntrypoint: _textToSpeechTaskEntrypoint,
                                      androidNotificationChannelName: 'Audio Service Demo',
                                      androidNotificationColor: 0xFF2196f3,
                                      androidNotificationIcon: 'mipmap/ic_launcher',
                                      params: {'title' : (widget.isTimer?'Timer':'StopWatch')}
                                    );
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
                                        onTap: () {
                                          AudioService.play();
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
                                        onTap: () {
                                          AudioService.stop();
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
    _stopWatch.onExecute.add(StopWatchExecute.start);
    _animationController.reset();
    playStatus.isPlaying = true;
    playStatus.reset = false;
    _animationController.forward();
  }

  void _pauseSetState(PlayStatus playStatus) {
    _stopWatch.onExecute.add(StopWatchExecute.stop);
    _animationController.reset();
    playStatus.isPlaying = false;
    _animationController.forward();
  }

  void _resetSetState(PlayStatus playStatus) {
    _stopWatch.onExecute.add(StopWatchExecute.reset);
    _animationController.reset();
    playStatus.isPlaying = false;
    playStatus.reset = true;
    _animationController.forward();
  }
}