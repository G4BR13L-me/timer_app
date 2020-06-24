library flutter_datetime_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speaker_timer/animations/blink.dart';
import 'dart:async';
import 'src/date_model.dart';
import 'src/datetime_picker_theme.dart';
import 'src/i18n_model.dart';

/*
*
* Library Flutter_datetime_picker
* Using to reimplement showTime Settings
*
* ALL CREDITS TO:
*   Flutter Library: https://pub.dev/packages/flutter_datetime_picker
*   Library GitHub: https://github.com/Realank/flutter_datetime_picker
*
**/

typedef DateChangedCallback(DateTime time);
typedef DateTimerCallback(DateTime time,int repeat,DateTime rest);
typedef DateCancelledCallback();
typedef String StringAtIndexCallBack(int index);

class DatePicker {
  ///
  /// Display date picker bottom sheet.
  ///
  static Future<DateTime> showDatePicker(
    BuildContext context, {
    bool showTitleActions: true,
    DateTime minTime,
    DateTime maxTime,
    DateChangedCallback onChanged,
    DateTimerCallback onConfirm,
    DateCancelledCallback onCancel,
    locale: LocaleType.en,
    DateTime currentTime,
    DatePickerTheme theme,
  }) async {
    return await Navigator.push(
        context,
        new _DatePickerRoute(
            showTitleActions: showTitleActions,
            onChanged: onChanged,
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: locale,
            theme: theme,
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            pickerModel: DatePickerModel(
                currentTime: currentTime, maxTime: maxTime, minTime: minTime, locale: locale)));
  }

  ///
  /// Display time picker bottom sheet.
  ///
  static Future<DateTime> showTimePicker(
    BuildContext context, {
    bool showTitleActions: true,
    bool showRepeatView: true,
    bool showSecondsColumn: true,
    DateChangedCallback onChanged,
    DateTimerCallback onConfirm,
    DateCancelledCallback onCancel,
    locale: LocaleType.en,
    DateTime currentTime,
    DatePickerTheme theme,
  }) async {
    return await Navigator.push(
        context,
        new _DatePickerRoute(
            showTitleActions: showTitleActions,
            showRepeatView: showRepeatView,
            onChanged: onChanged,
            onConfirm: onConfirm,
            onCancel: onCancel,
            locale: locale,
            theme: theme,
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            pickerModel: TimePickerModel(
                currentTime: currentTime, locale: locale, showSecondsColumn: showSecondsColumn)));
  }

}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.showRepeatView,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    theme,
    this.barrierLabel,
    this.locale,
    RouteSettings settings,
    pickerModel,
  })  : this.pickerModel = pickerModel ?? DatePickerModel(),
        this.theme = theme ?? DatePickerTheme(),
        super(settings: settings);

  final bool showTitleActions;
  final bool showRepeatView;
  final DateChangedCallback onChanged;
  final DateTimerCallback onConfirm;
  final DateCancelledCallback onCancel;
  final DatePickerTheme theme;
  final LocaleType locale;
  final BasePickerModel pickerModel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        onChanged: onChanged,
        locale: this.locale,
        route: this,
        pickerModel: pickerModel,
      ),
    );
    ThemeData inheritTheme = Theme.of(context, shadowThemeOnly: true);
    if (inheritTheme != null) {
      bottomSheet = new Theme(data: inheritTheme, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _DatePickerComponent extends StatefulWidget {
  _DatePickerComponent(
      {Key key, @required this.route, this.onChanged, this.locale, this.pickerModel});

  final DateChangedCallback onChanged;

  final _DatePickerRoute route;

  final LocaleType locale;

  final BasePickerModel pickerModel;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePickerComponent> with SingleTickerProviderStateMixin {
  FixedExtentScrollController leftScrollCtrl, middleScrollCtrl, rightScrollCtrl;
  String repeatController;
  String selectedTime;
  DateTime rest;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    repeatController = '1';
    selectedTime = "00:00:00";
    rest = DateTime(2020);
    controller = AnimationController(vsync: this,duration: Duration(seconds:1))
    ..addListener(() {
        if(controller.isCompleted)
          controller.reverse();
        else if(controller.isDismissed)
          controller.forward();
      });
    refreshScrollOffset();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void refreshScrollOffset() {
//    print('refreshScrollOffset ${widget.pickerModel.currentRightIndex()}');
    leftScrollCtrl =
        new FixedExtentScrollController(initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl =
        new FixedExtentScrollController(initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl =
        new FixedExtentScrollController(initialItem: widget.pickerModel.currentRightIndex());
  }

  @override
  Widget build(BuildContext context) {
    DatePickerTheme theme = widget.route.theme;
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation,
        builder: (BuildContext context, Widget child) {
          final double bottomPadding = MediaQuery.of(context).padding.bottom;
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(widget.route.animation.value, theme,
                  showTitleActions: widget.route.showTitleActions, showRepeatView:widget.route.showRepeatView,
                  bottomPadding: bottomPadding),
              child: GestureDetector(
                child: Material(
                  color: theme.backgroundColor ?? Colors.white,
                  child: _renderPickerView(theme),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(widget.pickerModel.finalTime());
    }
  }

  Widget _renderPickerView(DatePickerTheme theme) {
    Widget itemView = _renderItemView(theme);
    if (widget.route.showTitleActions) {
      return Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              _renderTitleActionsView(theme),
              itemView,
              if(widget.route.showRepeatView)
              Divider(color: theme.cancelStyle.color,thickness: 0.5,
              indent: 20,endIndent: 20,)
            ],
          ),
          _renderSubtitleView(theme),
          if(widget.route.showRepeatView)
            _renderTimerRestartView(theme)
        ],
      );
    }
    return itemView;
  }

  Widget _renderColumnView(
      ValueKey key,
      DatePickerTheme theme,
      StringAtIndexCallBack stringAtIndexCB,
      ScrollController scrollController,
      int layoutProportion,
      ValueChanged<int> selectedChangedWhenScrolling,
      ValueChanged<int> selectedChangedWhenScrollEnd) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
          padding: EdgeInsets.all(8.0),
          height: theme.containerHeight,
          decoration: BoxDecoration(color: theme.backgroundColor ?? Colors.white),
          child: NotificationListener(
              onNotification: (ScrollNotification notification) {
                if (notification.depth == 0 &&
                    selectedChangedWhenScrollEnd != null &&
                    notification is ScrollEndNotification &&
                    notification.metrics is FixedExtentMetrics) {
                  final FixedExtentMetrics metrics = notification.metrics;
                  final int currentItemIndex = metrics.itemIndex;
                  selectedChangedWhenScrollEnd(currentItemIndex);
                }
                return false;
              },
              child: CupertinoPicker.builder(
                  key: key,
                  backgroundColor: theme.backgroundColor ?? Colors.white,
                  scrollController: scrollController,
                  itemExtent: theme.itemHeight,
                  onSelectedItemChanged: (int index) {
                    selectedChangedWhenScrolling(index);
                  },
                  useMagnifier: true,
                  itemBuilder: (BuildContext context, int index) {
                    final content = stringAtIndexCB(index);
                    if (content == null) {
                      return null;
                    }
                    return Container(
                      height: theme.itemHeight,
                      alignment: Alignment.center,
                      child: Text(
                        content,
                        style: theme.itemStyle,
                        textAlign: TextAlign.start,
                      ),
                    );
                  }))),
    );
  }

  Widget _renderItemView(DatePickerTheme theme) {
    return Container(
      color: theme.backgroundColor ?? Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: widget.pickerModel.layoutProportions()[0] > 0
                ? _renderColumnView(
                    ValueKey(widget.pickerModel.currentLeftIndex()),
                    theme,
                    widget.pickerModel.leftStringAtIndex,
                    leftScrollCtrl,
                    widget.pickerModel.layoutProportions()[0], (index) {
                    widget.pickerModel.setLeftIndex(index);
                  }, (index) {
                    setState(() {
                      refreshScrollOffset();
                      _notifyDateChanged();
                    });
                  })
                : null,
          ),
          Text(
            widget.pickerModel.leftDivider(),
            style: theme.itemStyle,
          ),
          Container(
            child: widget.pickerModel.layoutProportions()[1] > 0
                ? _renderColumnView(
                    ValueKey(widget.pickerModel.currentLeftIndex()),
                    theme,
                    widget.pickerModel.middleStringAtIndex,
                    middleScrollCtrl,
                    widget.pickerModel.layoutProportions()[1], (index) {
                    widget.pickerModel.setMiddleIndex(index);
                  }, (index) {
                    setState(() {
                      refreshScrollOffset();
                      _notifyDateChanged();
                    });
                  })
                : null,
          ),
          Text(
            widget.pickerModel.rightDivider(),
            style: theme.itemStyle,
          ),
          Container(
            child: widget.pickerModel.layoutProportions()[2] > 0
                ? _renderColumnView(
                    ValueKey(widget.pickerModel.currentMiddleIndex() * 100 +
                        widget.pickerModel.currentLeftIndex()),
                    theme,
                    widget.pickerModel.rightStringAtIndex,
                    rightScrollCtrl,
                    widget.pickerModel.layoutProportions()[2], (index) {
                    widget.pickerModel.setRightIndex(index);
                    _notifyDateChanged();
                  }, null)
                : null,
          ),
        ],
      ),
    );
  }

  // Title View
  Widget _renderTitleActionsView(DatePickerTheme theme) {
    String done = _getTranslation('done');
    String cancel = _getTranslation('cancel');

    return Container(
      height: theme.titleHeight,
      decoration: BoxDecoration(
        color: theme.headerColor ?? theme.backgroundColor ?? Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsets.only(left: 16, top: 0),
              child: Text(
                '$cancel',
                style: theme.cancelStyle,
              ),
              onPressed: () {
                Navigator.pop(context);
                if (widget.route.onCancel != null) {
                  widget.route.onCancel();
                }
              },
            ),
          ),
          Container(
            height: theme.titleHeight,
            child: CupertinoButton(
              pressedOpacity: 0.3,
              padding: EdgeInsets.only(right: 16, top: 0),
              child: Text(
                '$done',
                style: theme.doneStyle,
              ),
              onPressed: () {
                Navigator.pop(context, widget.pickerModel.finalTime());
                if (widget.route.onConfirm != null) {
                  widget.route.onConfirm(widget.pickerModel.finalTime(),
                  int.parse(repeatController),rest);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Subtitle View
  Widget _renderSubtitleView(DatePickerTheme theme) {
    String hour = _getTranslation('hour');
    String minute = _getTranslation('minute');
    String second = _getTranslation('second');
    Size size = MediaQuery.of(context).size;

    return Positioned(
      top: size.height/17.3,
      child: Container(
        height: theme.titleHeight,
        width: size.width,
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: size.width/8.4),
              color: Colors.transparent,
              height: theme.titleHeight,
              child: Text(
                '$hour',
                style: theme.subTitleStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: size.width/4.4),
              color: Colors.transparent,
              height: theme.titleHeight,
              child: Text(
                '$minute',
                style: theme.subTitleStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: size.width/4.6),
              color: Colors.transparent,
              height: theme.titleHeight,
              child: Text(
                '$second',
                style: theme.subTitleStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Timer Restart View
  Widget _renderTimerRestartView(DatePickerTheme theme) {
    String title = _getTranslation('repeat');
    int times = int.parse(repeatController);
    if(times>1)
      controller.forward();
    else{
      controller.reset();
      controller.stop();
    }
      
    Size size = MediaQuery.of(context).size;

    return Positioned(
      top: size.height/2.6,
      child: Column(
        children: [
          Container(
            height: theme.titleHeight,
            width: size.width,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(title, style: theme.itemStyle),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:16.0,right:8.0),
                  child: GestureDetector(
                      onTap: times<=1? null: (){
                        setState(() {
                          repeatController = (times-1).toString();
                        });
                      }, 
                      child: Icon(Icons.remove,
                        color:times<=1? theme.subTitleStyle.color : theme.itemStyle.color)
                    ),
                ),

                Text(repeatController, style: theme.itemStyle),
                
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: GestureDetector(
                      onTap: (){
                        setState(() {
                          repeatController = (times+1).toString();
                        }); 
                      }, 
                      child: Icon(Icons.add,color: theme.itemStyle.color)
                    ),
                ),
              ],
            ),
          ),
          _renderTimerRestView(theme),
        ],
      )
    );
  }

  Widget _renderTimerRestView(DatePickerTheme theme) {
    String title = _getTranslation('rest time');
    int times = int.parse(repeatController);
    Size size = MediaQuery.of(context).size;

    return Container(
        height: theme.titleHeight,
        width: size.width,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text('$title :', style: theme.itemStyle),
            ),
            Padding(
              padding: const EdgeInsets.only(left:16.0,right:8.0),
              child: GestureDetector(
                  onTap: times<=1? null: (){
                    DatePicker.showTimePicker(
                      context, 
                      showTitleActions: true,
                      showRepeatView: false,
                      onConfirm: (date,repeat,_) {
                        setState(() {
                          rest = date;
                          selectedTime ="${date.hour}:${date.minute}:${date.second}";
                        });
                      }, 
                      currentTime: DateTime.now(),
                      theme: theme.apply(backgroundColor: Theme.of(context).buttonColor,
                      doneStyle: theme.doneStyle.apply(color: Theme.of(context).accentColor))
                    );
                  }, 
                  child: Blink(
                    controller: controller,
                    child: Text(selectedTime,
                      style:theme.itemStyle
                      .apply(color:times<=1? theme.subTitleStyle.color : theme.itemStyle.color)),
                  )
                ),
            ),
          ],
        ),
      );
  }
  
  String _getTranslation(String word) {
    return i18nObjInLocale(widget.locale)[word];
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, this.theme,
      {this.itemCount, this.showTitleActions, this.showRepeatView, this.bottomPadding = 0});

  final double progress;
  final int itemCount;
  final bool showTitleActions;
  final bool showRepeatView;
  final DatePickerTheme theme;
  final double bottomPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = theme.containerHeight;
    if (showTitleActions) {
      if(showRepeatView)
        maxHeight += 3.5*theme.titleHeight;
      else
        maxHeight += theme.titleHeight;
    }

    return new BoxConstraints(
        minWidth: constraints.maxWidth,
        maxWidth: constraints.maxWidth,
        minHeight: 0.0,
        maxHeight: maxHeight + bottomPadding);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return new Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}