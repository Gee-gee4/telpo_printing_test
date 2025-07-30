// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:telpo_flutter_sdk/telpo_flutter_sdk.dart';
import 'package:telpo_test/printer_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle receiptStyle = TextStyle(fontFamily: 'Courier', fontSize: 16);
    final TextStyle balanceStyle = TextStyle(fontFamily: 'Courier', fontSize: 14, color: Colors.red);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Receipt', style: TextStyle(color: Colors.white70)),
        centerTitle: true,
        backgroundColor: Colors.orange[600],
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.white70),
          onPressed: () {
            print('🏠 HOME BUTTON PRESSED!');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Home button works!')));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text('SAHARA FCS', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Center(child: Text('CMB Station')),
                const SizedBox(height: 8),
                const Center(
                  child: Text('SALE', style: TextStyle(decoration: TextDecoration.underline)),
                ),
                const SizedBox(height: 8),
                Text('TERM# 8458cn34e3kf343', style: receiptStyle),
                Text('REF# TR45739547549219', style: receiptStyle),

                Divider(),

                // Product listing header
                Text('Prod    Price  Qty  Total', style: receiptStyle.copyWith(fontWeight: FontWeight.bold)),

                const SizedBox(height: 4),

                Divider(),
                Text('Petrol    200  1  200', style: receiptStyle),
                Text('Diesel    100  3  300', style: receiptStyle),
                Divider(),

                _row('Cash', '1000', balanceStyle),
                _row('Change', '500', receiptStyle),

                Divider(),

                _row('Date', DateTime.now().toString().substring(0, 19), receiptStyle),
                _row('Served By', 'Gee', receiptStyle),
                Divider(),

                // Approval section (only for card sales)
                const Center(
                  child: Text('THANK YOU', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Center(child: Text('CUSTOMER COPY')),
                const SizedBox(height: 4),
                const Center(child: Text('Powered by Sahara FCS', style: TextStyle(fontSize: 11))),
              
                
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('...........................................................');
          print("🔔 Print button pressed");

          try {
            final printer = PrinterService();

            final result = await printer.printReceipt(
              title: 'SAHARA FCS',
              station: 'CMB Station',
              items: ['Petrol    200  1  200', 'Diesel    100  3  300'],
              cash: '1000',
              change: '500',
              date: DateTime.now().toString().substring(0, 19),
              cashier: 'Gee',
            );

            print('✅ Final print result: $result');

            if (result == PrintResult.success) {
              print('🎉 Print completed successfully!');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Receipt printed successfully!'), backgroundColor: Colors.green));
            } else {
              print('⚠️ Print completed with result: $result');
            }
          // ignore: unused_catch_stack
          } catch (e, stack) {
            print('❌ Error during printing: $e');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Print error: $e'), backgroundColor: Colors.red));
          }
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.print, color: Colors.white),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _row(String label, String value, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Expanded(
            child: Text(value, style: style, textAlign: TextAlign.right, softWrap: true),
          ),
        ],
      ),
    );
  }
}
