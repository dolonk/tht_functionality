
import 'package:flutter/material.dart';
import 'package:functionality_operation/table_created/table_created.dart';
import 'package:functionality_operation/textediting_system/character_alingment.dart';
import 'package:functionality_operation/textediting_system/text_editing.dart';
import 'example.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: BarCodeGenerator()
    );
  }
}












