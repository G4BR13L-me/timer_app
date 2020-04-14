import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speaker_timer/controller/status.dart';


/*
*  Adapted from 
*  https://github.com/mjohnsullivan/dashcast/blob/flutterEurope/lib/wave.dart
*/
class Wave extends StatefulWidget {
  final Size size;

  const Wave({Key key, @required this.size}) : super(key: key);

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  List<Offset> _points;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
      upperBound: 2 * pi,
    );
    
    _initPoints();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayStatus>(
          builder: (context, player, child) {
            if (player.isPlaying) {
              _controller.repeat();
            } else {
              _controller.stop();
            }
            return child;
          },
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget child) {
              return ClipPath(
                clipper: WaveClipper(_points),
                child: BlueGradient(),
              );
            },
          ),
        );
      }
    
      /// Generates a random starting configuration for a 'sound wave' pattern.
      void _initPoints() {
        _points = [];
        Random r = Random();
        _widthStart = (5*widget.size.width/12).round();
        _widthEnd = (7*widget.size.width/12).round();
        for (int i = _widthStart; i < _widthEnd; i++) {
          double x = i.toDouble();
    
          // Set this point's y-coordinate to a random value
          // no greater than 50% of the container's height
          double y = r.nextDouble() * (widget.size.height*5);
    
          _points.add(Offset(x, y));
        }
      }
    }

int _widthStart;
int _widthEnd;


class WaveClipper extends CustomClipper<Path> {
  List<Offset> _wavePoints;

  WaveClipper(this._wavePoints);

  @override
  Path getClip(Size size) {
    var path = Path();
    _modulateRandom(size);
    path.addPolygon(_wavePoints, false);

    path.lineTo(_widthEnd.toDouble(), size.height);
    path.lineTo(_widthStart.toDouble(), size.height);
    path.close();
    return path;
  }

  /// Modifies each point randomly by a maximum of +/- [maxDiff] pixels
  void _modulateRandom(Size size) {
    // The maximum number of pixels that points on a random wave can change by.
    final maxDiff = 3.0;
    Random r = Random();
    for (int i = 0; i < _wavePoints.length; i++) {
      var point = _wavePoints[i];

      // Generate a random number between  -maxDiff and +maxDiff
      double diff = maxDiff - r.nextDouble() * maxDiff * 2;

      // Ensure that point is constrained between 0 and 50% of the container's height
      double newY = max(0.0, point.dy + diff);
      newY = min(size.height*0.5, newY);

      Offset newPoint = Offset(point.dx, newY);
      _wavePoints[i] = newPoint;
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class BlueGradient extends StatelessWidget {
  final overlayHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: overlayHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [
            Colors.blue,
            Colors.blue.withOpacity(0.25),
          ],
        ),
      ),
    );
  }
}