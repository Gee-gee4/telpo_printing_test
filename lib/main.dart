// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:telpo_test/home_page.dart';
import 'package:telpo_test/printer_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final printer = PrinterService();
  final connected = await printer.connect();

  if (connected) {
    print('✅ Printer connected');
  } else {
    print('❌ Failed to connect to printer');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage()
    );
  }
}