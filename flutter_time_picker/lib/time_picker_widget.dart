import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker/extensions/index.dart';
import 'package:flutter_time_picker/timepicker/index.dart';

class TimePickerWidget extends StatefulWidget {
  final void Function(DateTime) onTimeChanged;
  final DateTime minTime;
  final DateTime maxTime;
  final DateTime timestamp;
  final Key key;

  TimePickerWidget(
      {this.timestamp,
      this.onTimeChanged,
      this.minTime,
      this.maxTime,
      this.key})
      : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  bool isAdjusted = false;
  bool isValid = false;
  DateTime updatedDateTime;

  @override
  void initState() {
    super.initState();
    updatedDateTime = widget.timestamp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) {
                return CustomTimepicker(
                    initialTime: widget.timestamp,
                    minTime: widget.minTime,
                    maxTime: widget.maxTime,
                    onChanged: (DateTime date) {
                      if (date != widget.timestamp ||
                          date == widget.timestamp) {
                        setState(() {
                          updatedDateTime = date;
                          isAdjusted = true;
                          isValid = true;
                          widget.onTimeChanged(date);
                        });
                      }
                    });
              });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(2))),
          height: 50,
          child: Text(getMessage()),
        ));
  }

  String getMessage() {
    var validAdjustedEntry = isValid && isAdjusted;
    return DateExtensions.formatTohhmma(
        validAdjustedEntry ? updatedDateTime : widget.timestamp);
  }
}
