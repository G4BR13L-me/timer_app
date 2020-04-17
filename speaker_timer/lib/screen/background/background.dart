import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speaker_timer/controller/status.dart';
import 'package:speaker_timer/screen/background/widgets/app_bar.dart';
import 'package:speaker_timer/screen/background/widgets/crystal.dart';
import 'package:speaker_timer/screen/background/widgets/hourgalss_painter.dart';
import 'package:speaker_timer/screen/background/widgets/sand.dart';
import 'package:speaker_timer/screen/background/widgets/wave.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';



class Background extends StatefulWidget {
  final int duration = 20;

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: widget.duration));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final Image img = Image.asset(
      MediaQuery.of(context).orientation == Orientation.landscape
          ? 'assets/hourglass_Landscape.png'
          : 'assets/hourglass.png',
      fit: BoxFit.fill,
      //width: 2.0 / 3.0 * size.width,
      //height: size.height * 0.8,
    );

    return SafeArea(
      child: Container(
          color: Colors.white,
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              FutureBuilder(
                future: _loadImage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData)
                    return FittedBox(
                      child: SizedBox(
                        width: snapshot.data.width.toDouble(),
                        height: snapshot.data.height.toDouble(),
                        child: CustomPaint(
                          painter: HourglassPainter(snapshot.data),
                        ),
                      ),
                    );
                  else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              ),

              //CustomAppBar(),

              // TODO: ADD SAND RECT AND DROP EFFECT

              /*Container(
                height: size.height,
                width: size.width,
                padding:EdgeInsets.only(left: size.width*0.2,right: 2.0,top: size.height*0.02,bottom: size.height*0.05),
                child: img,
              ),
              Center(child: Crystal(size.width, size.height)),
              
              /*Transform.translate(
                child: Crystal(img.width, img.height),
                offset: Offset(img.width/2.0, img.height/2.0),
              ),*/
              //Crystal(img.width, img.height)*/
            ],
          )),
    );
  }

  Future<ui.Image> _loadImage() async {
    final byteData = await rootBundle.load('assets/hourglass.png');

    final file = File('${(await getTemporaryDirectory()).path}/hourglass.png');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    final data = await file.readAsBytes();
    return await decodeImageFromList(data);
  }
}
