import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'screens/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Log',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Navigation(),
    );
  }
}
