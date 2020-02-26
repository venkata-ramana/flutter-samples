import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker/extensions/index.dart';

const double _kPickerSheetHeight = 216.0;

class CustomTimepicker extends StatefulWidget {
  final DateTime initialTime;
  final DateTime minTime;
  final DateTime maxTime;
  final Function onChanged;
  CustomTimepicker(
      {@required this.initialTime, @required this.minTime, @required this.maxTime, @required this.onChanged});

  @override
  _CustomTimepickerState createState() => _CustomTimepickerState();
}

class _CustomTimepickerState extends State<CustomTimepicker> {
  DateTime updatedDateTime;
  bool isValid = true;
  bool isAdjusted = true;

  @override
  Widget build(BuildContext context) {
    return _buildBottomPicker(
        context,
        CupertinoDatePicker(
          backgroundColor: Theme.of(context).cardColor,
          mode: CupertinoDatePickerMode.time,
          initialDateTime: widget.initialTime,
          minimumDate: widget.minTime,
          maximumDate: widget.maxTime,
          use24hFormat: false,
          onDateTimeChanged: (DateTime changedDateTime) {
            setState(() {
              updatedDateTime = changedDateTime;
              var minTime = DateExtensions.trimSeconds(widget.minTime);
              var maxTime = DateExtensions.trimSeconds(widget.maxTime);
              if (changedDateTime.isBefore(minTime)) {
                updatedDateTime = updatedDateTime.add(Duration(days: 1));
              }
              if (changedDateTime.isAfter(maxTime)) {
                updatedDateTime = updatedDateTime.add(Duration(days: -1));
              }
              isAdjusted = true;
              if (updatedDateTime != null &&
                  maxTime.difference(updatedDateTime) >= Duration(seconds: 0) &&
                  updatedDateTime.difference(minTime) >= Duration(seconds: 0)) {
                isValid = true;
              } else {
                isValid = false;
              }
            });
          },
        ));
  }

  Widget _buildBottomPicker(BuildContext context, Widget picker) {
    return Material(
      child: Container(
        height: _kPickerSheetHeight + 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(2))),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: isAdjusted && !isValid
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    'Min Time: ${_getFormattedDate(widget.minTime)}',
                                    maxLines: 2,
                                  ),
                                  Text(
                                    'Max Time: ${_getFormattedDate(widget.maxTime)}',
                                    maxLines: 2,
                                  )
                                ])
                          : Text(''),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      GestureDetector(
                        onTap: () {
                          if (isValid && isAdjusted) {
                            widget.onChanged(updatedDateTime != null
                                ? updatedDateTime
                                : widget.initialTime);
                          }

                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.check,
                          color: customColors['liteGreen'],
                          size: 32,
                        ),
                      ),
                      SizedBox(width: 16),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.close,
                            color: customColors['liteRed'],
                            size: 32,
                          ))
                    ]),
                  ],
                )),
            Container(
              height: _kPickerSheetHeight,
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 22.0,
                ),
                child: SafeArea(
                  top: false,
                  child: picker,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    return DateExtensions.formatToMMMdyhhmma(date);
  }
}

const Map<String, Color> customColors = {
  "liteGreen": Color.fromRGBO(152, 180, 51, 1.0),
  "liteRed": Color.fromRGBO(236, 134, 134, 1.0),
  "liteGold": Color.fromRGBO(196, 184, 147, 1.0),
  "liteCyan": Color.fromRGBO(100, 195, 209, 1.0),
  "litePurple": Color.fromRGBO(151, 133, 194, 1.0),
  "dullYellow": Color.fromRGBO(247, 173, 83, 1.0),
  "remoteColor": Color.fromRGBO(100, 195, 209, 1.0),
  "leaveColor": Color.fromRGBO(252, 154, 67, 1.0),
  "holidayColor": Color.fromRGBO(194, 184, 157, 1.0),
  "liteMaroon": Color.fromRGBO(255, 100, 100, 1.0),
  "pendingColor": Color.fromRGBO(247, 173, 83, 1)
};
