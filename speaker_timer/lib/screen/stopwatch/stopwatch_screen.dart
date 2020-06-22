import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speaker_timer/animations/blink.dart';
import 'package:speaker_timer/controller/status.dart';
import 'package:speaker_timer/animations/expand_animation.dart';
import 'package:speaker_timer/controller/text_player.dart';
import 'package:speaker_timer/screen/stopwatch/widgets/button.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:vibration/vibration.dart';
import 'widgets/time_text.dart';

class StopWatch extends StatefulWidget {
  final PlayStatus player;
  final PlayStatus otherPlayer;
  final int duration;
  final int repeat;
  final String title;

  StopWatch(this.player, this.otherPlayer, this.duration, this.title,{this.repeat});

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
  static String getDisplayTime(int value) {
    String result = '';
    if (value <= 50) {
      return '00:00:00';
      /*value = (-value);
      result = '-';*/
    }
    String second = StopWatchTimer.getDisplayTimeSecond(value);
    String hour = getDisplayHour(value);
    value -= int.parse(hour) * 1440000;
    String minute = getDisplayTimeMinute(value);

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
    with TickerProviderStateMixin {
  StopWatchTimer _stopWatch;
  AnimationController _animationController;
  AnimationController _blinkController;
  Animation<double> _animation;
  int currentTimerRun=1;

  @override
  void initState() {
    super.initState();

    _stopWatch = StopWatchTimer();

    //Send the stopwatch time to the audio_service isolate
    _stopWatch.rawTime.listen((value) 
      async {
         AudioService.customAction("setTime${widget.title}", value);

        // Handle Timer end
        if(widget.title == 'Timer')
          if(widget.duration - value<=50){
            if(currentTimerRun!=widget.repeat){
              //TODO:RESET TIMER IN ORDER TO REPEAT THE COUNTDOWN
            }else{
              widget.player.isCompleteCount = true;
              if((widget.otherPlayer?.reset) ?? true) AudioService.pause();
              _pauseSetState(widget.player);
              if (await Vibration.hasCustomVibrationsSupport()) {
                Vibration.vibrate(
                  pattern: [300, 150, 450,1000,1000,1000,300, 150, 450,1000,1000,1000,300, 150, 450,1000,1000,1000,300, 150, 450], 
                  intensities: [255, 0, 255,0,0,0,255, 0, 255,0,0,0,255, 0, 255,0,0,0,255, 0, 255]);
              } else {
                Vibration.vibrate();
                await Future.delayed(Duration(milliseconds: 500));
                Vibration.vibrate();
              }
              //Vibration.vibrate(
              //  pattern: [300, 150, 450], intensities: [255, 0, 255],repeat: 0);
              _blinkController.forward();
            }
          }
      });

    //if the app notification buttons are pressed then this event
    //is fired in order to update the layout
    AudioService.customEventStream.listen((event) {
      if (widget.title == 'Timer')
        switch (event) {
          case 'playingTimer':
            _playSetState(widget.player);
            break;
          case 'pauseTimer':
            _pauseSetState(widget.player);
            break;
          case 'stopTimer':
            _resetSetState(widget.player);
            break;
          default:
            break;
        }
      else
        switch (event) {
          case 'playingStopwatch':
            _playSetState(widget.player);
            break;
          case 'pauseStopwatch':
            _pauseSetState(widget.player);
            break;
          case 'stopStopwatch':
            _resetSetState(widget.player);
            break;
          default:
            break;
        }
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    if (widget.title == 'Timer'){
      _blinkController = AnimationController(vsync: this,duration: Duration(seconds: 1))
      ..addListener(() {
        if(_blinkController.isCompleted)
          _blinkController.reverse();
        else if(_blinkController.isDismissed)
          _blinkController.forward();
      });
    }

    _animation = Tween<double>(begin: 0, end: 30).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _stopWatch.dispose();
    _blinkController?.dispose();
    _animationController.dispose();
  }

  Widget _playButton(Function onTap) {
    return ExpandAnimation(
      fixHeight: true,
      child: Button(onTap: onTap, type: 'play'),
      animation: _animation,
    );
  }

  Widget _pauseButton(bool shouldPlay) {
    return ExpandAnimation(
        fixWidth: true,
        child: Button(
            onTap: () {
              if (shouldPlay) AudioService.pause();

              _pauseSetState(widget.player);
            },
            type: 'pause'),
        animation: _animation);
  }

  Widget _resetButton(bool shouldPlay) {
    return ExpandAnimation(
        fixHeight: true,
        child: Button(
            onTap: () {
              if (shouldPlay) AudioService.stop();

              //reset the timer screen to select another time
              widget.player.isTimerSelected = false;
              _resetSetState(widget.player);
            },
            type: 'reset'),
        animation: _animation);
  }

  @override
  Widget build(BuildContext context) {
    bool isTimer = widget.title == 'Timer';

    //True if other audioservice isn't playing
    //It makes only one audioservice available to play at a time
    bool shouldPlay = (widget.otherPlayer?.reset) ?? true;

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
                if (isTimer)
                  // Show Timer
                  return Blink(
                    child: TimeText(StopWatch.getDisplayTime(widget.duration - snapshot.data)),
                    controller:_blinkController
                  );
                else {
                  // Vibrate every time the time is multiple of the widget.duration parameter
                  if ((snapshot.data % widget.duration < 100) &&
                      snapshot.data > 100)
                    Vibration.vibrate(
                        pattern: [300, 150, 450], intensities: [255, 0, 255]);
                  return TimeText(StopWatchTimer.getDisplayTime(snapshot.data));
                }
              }),
          SizedBox(
            height: 20,
          ),

          /// BUTTONS
          Stack(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  widget.player.isPlaying
                      ? 
                        //clock is running state >> display a pause button
                        _pauseButton(shouldPlay)
                      : widget.player.reset
                          ?
                          //initial state >> display a play button
                          _playButton(() async {
                              if (shouldPlay) {
                                await AudioService.start(
                                    backgroundTaskEntrypoint:
                                        _textToSpeechTaskEntrypoint,
                                    androidNotificationChannelName:
                                        'Audio Service Demo',
                                    androidNotificationColor: 0xFF2196f3,
                                    androidNotificationIcon:
                                        'mipmap/ic_launcher',
                                    params: {'title': widget.title});
                              }
                              _playSetState(widget.player);
                            })
                          :
                          widget.player.isCompleteCount?
                          //timer complete state >> display a reset button
                          _resetButton(shouldPlay)
                          :
                          //pause state >> display play and reset buttons
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _playButton(() {
                                  if (shouldPlay) AudioService.play();

                                  _playSetState(widget.player);
                                }),
                                //Spacing the Widgets
                                SizedBox(
                                  width: 45,
                                ),

                                _resetButton(shouldPlay)
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

  //>>ALL THESE SETSTATE FUNCTIONS UPDATE THE SCREEN LAYOUT<<
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
    Vibration.cancel();
    _stopWatch.onExecute.add(StopWatchExecute.reset);
    _animationController.reset();
    playStatus.isPlaying = false;
    playStatus.reset = true;
    _animationController.forward();
  }
}
