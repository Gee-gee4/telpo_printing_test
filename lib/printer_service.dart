// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:telpo_flutter_sdk/telpo_flutter_sdk.dart';

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  final TelpoFlutterChannel _printer = TelpoFlutterChannel();
  bool _isConnected = false;
  bool _isConnecting = false;

   Future<bool> _safeCall(Future<bool> Function() fn) async {
    try {
      return await fn().timeout(const Duration(seconds: 5), onTimeout: () {
        _isConnected = false;
        return false;
      });
    } catch (e) {
      _isConnected = false;
      return false;
    }
  }

  Future<bool> connect() async {
    if (_isConnecting) return false;
    _isConnecting = true;
    
    _isConnected = await _safeCall(() async {
      await disconnect(); // Clean up any existing connection
      final result = await _printer.connect();
      return result ?? false;
    });
    
    _isConnecting = false;
    return _isConnected;
  }

  Future<bool> isConnected() async {
    return await _safeCall(() async {
      if (!_isConnected) return false;
      final result = await _printer.isConnected();
      _isConnected = result ?? false;
      return _isConnected;
    });
  }

  Future<void> disconnect() async {
    await _safeCall(() async {
      await _printer.disconnect();
      _isConnected = false;
      return true;
    });
  }

  Future<PrintResult> printReceipt({
    required String title,
    required String station,
    required List<String> items,
    required String cash,
    required String change,
    required String date,
    required String cashier,
  }) async {
    if (!_isConnected) {
      final reconnected = await connect();
      if (!reconnected) return PrintResult.other;
    }
    print("🔔 Building print sheet...");

    final sheet = TelpoPrintSheet();

    // Header
    sheet.addElement(PrintData.text(title, alignment: PrintAlignment.center, fontSize: PrintedFontSize.size34));

    sheet.addElement(PrintData.text(station, alignment: PrintAlignment.center, fontSize: PrintedFontSize.size24));
    // sheet.addElement(PrintData.text('--------------------------------'));
    sheet.addElement(PrintData.space(line: 4));
    sheet.addElement(PrintData.text('SALE', alignment: PrintAlignment.center, fontSize: PrintedFontSize.size24));
    sheet.addElement(PrintData.text('TERM# 8458cn34e3kf343', fontSize: PrintedFontSize.size24));
    sheet.addElement(PrintData.text('REF# TR45739547549219', fontSize: PrintedFontSize.size24));
    sheet.addElement(PrintData.text('----------------------------------------------------------------'));

    // Products
    sheet.addElement(PrintData.text('Prod    Price  Qty  Total', fontSize: PrintedFontSize.size24));
    for (final item in items) {
      print('🛒 Adding item: $item');
      sheet.addElement(PrintData.text(item, fontSize: PrintedFontSize.size24));
    }

    sheet.addElement(PrintData.text('----------------------------------------------------------------'));
    sheet.addElement(PrintData.text('Cash     $cash', fontSize: PrintedFontSize.size24));
    sheet.addElement(PrintData.text('Change   $change', fontSize: PrintedFontSize.size24));
    sheet.addElement(PrintData.text('----------------------------------------------------------------'));
    sheet.addElement(PrintData.text('Date: $date', fontSize: PrintedFontSize.size24));
    sheet.addElement(PrintData.text('Served By: $cashier', fontSize: PrintedFontSize.size24));
    sheet.addElement(PrintData.text('----------------------------------------------------------------'));

    // Footer
    sheet.addElement(PrintData.text('THANK YOU', alignment: PrintAlignment.center, fontSize: PrintedFontSize.size24));
    sheet.addElement(
      PrintData.text('CUSTOMER COPY', alignment: PrintAlignment.center, fontSize: PrintedFontSize.size24),
    );
    sheet.addElement(
      PrintData.text('Powered by Sahara FCS', alignment: PrintAlignment.center, fontSize: PrintedFontSize.size24),
    );
    sheet.addElement(PrintData.space(line: 20));

    print("🖨️ Sending to printer...");

    try {
      final result = await _printer.print(sheet);
      print("📤 Print result: $result");
      return result;
    } catch (e) {
      print("❌ Print error: $e");
      return PrintResult.other;
    }
  }
}
