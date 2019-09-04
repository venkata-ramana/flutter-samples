import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign align;

  CustomText({this.text, this.fontSize, this.align = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white, fontSize: fontSize, fontWeight: FontWeight.w300),
      textAlign: align,
    );
  }
}
