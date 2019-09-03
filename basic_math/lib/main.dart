import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calc',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _output;
  String _inputExpression;

  TextEditingController _controller;
  Parser _parser;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _parser = Parser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: <Widget>[
            TextField(
              autofocus: true,
              controller: _controller,
            ),
            SizedBox(
              height: 8,
            ),
            RaisedButton(
              onPressed: () => _doCalculation(),
              child: Text('Calculate'),
            ),
            SizedBox(
              height: 32,
            ),
            Text(
              _output ?? '',
              style: TextStyle(fontSize: 32),
            )
          ],
        ),
      ),
    );
  }

  void _doCalculation() {
    _inputExpression = _controller.value.text;

    setState(() {
      try {
        Expression exp = _parser.parse(_inputExpression);
        _output = exp.evaluate(EvaluationType.REAL, ContextModel()).toString();
      } catch (ex) {
        _output = 'Invalid Expression';
      }
    });
  }
}
