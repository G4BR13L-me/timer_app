import 'package:flutter/material.dart';

class Sand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }


  static Widget builder (BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // controls the heigth of the triangle
        for (var i = 0; i < 25; i++) 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // controls the width of the triangle
              for (var j = 0; j < i*1.25; j++)
                _sand(context)
              
            ],
          ),
      ],
    );
    
  }

  static Widget _sand (BuildContext context, {double posX = 0, double posY = 0}) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.amber),
    );

  }
}