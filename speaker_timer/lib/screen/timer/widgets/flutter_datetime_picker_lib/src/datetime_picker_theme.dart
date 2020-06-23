import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speaker_timer/screen/timer/widgets/flutter_datetime_picker_lib/flutter_datetime_picker.dart';

// Migrate DiagnosticableMixin to Diagnosticable until
// https://github.com/flutter/flutter/pull/51495 makes it into stable (v1.15.21)
class DatePickerTheme with DiagnosticableMixin {
  final TextStyle cancelStyle;
  final TextStyle doneStyle;
  final TextStyle subTitleStyle;
  final TextStyle itemStyle;
  final Color backgroundColor;
  final Color headerColor;
  final double containerHeight;
  final double titleHeight;
  final double itemHeight;

  const DatePickerTheme({
    this.subTitleStyle = const TextStyle(color: Colors.grey, fontSize: 14),
    this.cancelStyle = const TextStyle(color: Colors.black54, fontSize: 16),
    this.doneStyle = const TextStyle(color: Colors.blue, fontSize: 16),
    this.itemStyle = const TextStyle(color: Color(0xFF000046), fontSize: 18),
    this.backgroundColor = Colors.white,
    this.headerColor,
    this.containerHeight = 210.0,
    this.titleHeight = 44.0,
    this.itemHeight = 36.0,
  });

  DatePickerTheme apply({
    TextStyle subTitleStyle,
    TextStyle cancelStyle,
    TextStyle doneStyle,
    TextStyle itemStyle,
    Color backgroundColor,
    Color headerColor,
    double containerHeight,
    double titleHeight,
    double itemHeight,
  }){

    return DatePickerTheme(
      subTitleStyle:subTitleStyle??this.subTitleStyle, cancelStyle:cancelStyle??this.cancelStyle, 
      doneStyle:doneStyle??this.doneStyle, itemStyle:itemStyle??this.itemStyle,
      backgroundColor:backgroundColor??this.backgroundColor, headerColor:headerColor??this.headerColor,
      containerHeight:containerHeight??this.containerHeight, titleHeight:titleHeight??this.titleHeight,
      itemHeight:itemHeight??this.itemHeight, 
    );
  }
}
