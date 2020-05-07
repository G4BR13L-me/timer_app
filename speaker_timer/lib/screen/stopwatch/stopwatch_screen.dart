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

    _animation = Tween<double>(begin: 0, end: 30).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchNewTimer.dispose();
    _animationController.dispose();
  }

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
                  style: TextStyle(color: Color(0xFFEAE9EA), fontSize: 45.0),
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
                child: SizedBox(
                  height: 40,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _stopWatchNewTimer.isRunning()
                      ?
                      //Pause Button
                      ExpandAnimation(
                          fixWidth: true,
                          child: Button(
                              onTap: () async {
                                _pauseSetState(widget.player);
                                await AudioService.pause();
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
                                    _playSetState(widget.player);
                                    await AudioService.start(
                                      backgroundTaskEntrypoint: () {
                                        AudioServiceBackground.run(() =>
                                            TextPlayerTask('StopWatch',
                                                stopWatch: _stopWatchNewTimer));
                                      },
                                      androidNotificationChannelName:
                                          'Audio Service Demo',
                                      androidStopOnRemoveTask: true,
                                      notificationColor: 0xFFDF9595,
                                      androidNotificationIcon:
                                          'drawable/ic_hourglass_icon',
                                    );
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
                                          await AudioService.play();
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
                                          await AudioService.stop();
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
    _stopWatchNewTimer.onExecute.add(StopWatchExecute.stop);
    _animationController.forward();
  }

  void _resetSetState(PlayStatus playStatus) {
    _animationController.reset();
    playStatus.isPlaying = false;
    playStatus.reset = true;
    _stopWatchNewTimer.onExecute.add(StopWatchExecute.reset);
    _animationController.forward();
  }
}