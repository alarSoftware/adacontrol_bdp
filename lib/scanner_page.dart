import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool scanned = false;

  void onDetect(BarcodeCapture capture) {
    if (scanned) return;
    final code = capture.barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      scanned = true;
      Navigator.pop(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: onDetect,
      ),
    );
  }
}
