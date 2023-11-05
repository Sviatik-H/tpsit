import 'package:flutter/material.dart';
import 'cronometro.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cronometro Flutter',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: Cronometro(),
    );
  }
}




