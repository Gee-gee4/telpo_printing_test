// ignore_for_file: avoid_print

import 'package:telpo_flutter_sdk/telpo_flutter_sdk.dart';

class PrinterService {
  static final PrinterService _instance = PrinterService._internal();
  factory PrinterService() => _instance;
  PrinterService._internal();

  final TelpoFlutterChannel _printer = TelpoFlutterChannel();

  Future<bool> connect() async {
    try {
      final result = await _printer.connect();
      print("🔌 Connection result: $result");
      return result == true;
    } catch (e) {
      print("❌ Connection error: $e");
      return false;
    }
  }

  Future<bool> isConnected() async {
    try {
      final result = await _printer.isConnected() ?? false;
      print("✅ isConnected check: $result");
      return result;
    } catch (e) {
      print("❌ isConnected error: $e");
      return false;
    }
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
