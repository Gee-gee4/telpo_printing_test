import 'package:flutter/material.dart';
import 'package:telpo_test/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), // No loading screen here
    );
  }
}