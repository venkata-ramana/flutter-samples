import 'package:calculator/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String _output = '', _inputExpression = '';

  Parser _parser;

  @override
  void initState() {
    super.initState();
    _parser = Parser();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white10,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: CustomText(
                    text: _output,
                    fontSize: 60,
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
              margin: EdgeInsets.symmetric(vertical: 4),
              width: double.infinity,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 24,
              ),
            ),
            Container(
                height: screenHeight / 1.8,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Row(
                  children: <Widget>[
                    _buildNumbersWithMathSymbols(context),
                    _buildMathSymbols(context),
                    _buildSideDrawer(context),
                  ],
                ))
          ],
        ));
  }

  Widget _buildNumbersWithMathSymbols(BuildContext context) {
    return Expanded(
        child: Container(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        children: <Widget>[
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: <Widget>[
                _button('7', () => _doOperation('7')),
                _button('8', () => _doOperation('8')),
                _button('9', () => _doOperation('9')),
              ]),
              Row(children: <Widget>[
                _button('4', () => _doOperation('4')),
                _button('5', () => _doOperation('5')),
                _button('6', () => _doOperation('6')),
              ]),
              Row(children: <Widget>[
                _button('1', () => _doOperation('1')),
                _button('2', () => _doOperation('2')),
                _button('3', () => _doOperation('3')),
              ]),
            ],
          )),
          Container(
              child: Row(
            children: <Widget>[
              _button('.', () => _doOperation('.')),
              _button('0', () => _doOperation('0')),
              _button('DEL', deleteChar, fontSize: 20),
            ],
          )),
        ],
      ),
    ));
  }

  Widget _buildMathSymbols(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth / 5,
      child: Column(
        children: <Widget>[
          _button('/', () => _doOperation('/')),
          _button('*', () => _doOperation('*')),
          _button('-', () => _doOperation('-')),
          _button('+', () => _doOperation('+')),
          _button('=', _calculate,
              bgColor: Colors.red, buttonWidth: screenWidth / 5),
        ],
      ),
    );
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Container(
      width: 30,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.white24),
      child: Center(
          child: Icon(
        Icons.keyboard_arrow_left,
        size: 25,
        color: Colors.white,
      )),
    );
  }

  Widget _button(String text, Function function,
      {double fontSize = 40, Color bgColor, double buttonWidth}) {
    return Expanded(
      child: GestureDetector(
        onTap: function,
        child: Container(
          width: buttonWidth,
          decoration: bgColor != null ? BoxDecoration(color: bgColor) : null,
          child: Center(
            child: CustomText(
              text: text,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }

  void _calculate() {
    var result = _doCalculation();
    if (result != null) {
      setState(() {
        _inputExpression = '';
        _output =
            result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 2);
      });
    }
  }

  void _doOperation(String operation) {
    double isNumber = double.tryParse(operation);
    if (_inputExpression.isEmpty ||
        isNumber != null ||
        (isNumber == null &&
            !_inputExpression.contains(
                operation, _inputExpression.length - 1))) {
      _inputExpression = '$_inputExpression$operation';
      setState(() {
        _output = _inputExpression;
      });
    }
  }

  double _doCalculation() {
    try {
      Expression exp = _parser.parse(_inputExpression);
      return exp.evaluate(EvaluationType.REAL, ContextModel());
    } catch (ex) {
      return null;
    }
  }

  void deleteChar() {
    _inputExpression =
        _inputExpression.substring(0, _inputExpression.length - 1);
    setState(() {
      _output = _inputExpression;
    });
  }
}
