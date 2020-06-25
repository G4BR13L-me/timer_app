import 'package:flutter/material.dart';

class Configuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('CONFIG'),
        centerTitle: true,
      ),
      body: Container(
        width:double.infinity,
        height:double.infinity,
      ),
    );
  }
}