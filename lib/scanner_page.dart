import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _scanned = false;

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;

    final code = capture.barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    _scanned = true;
    Navigator.pop(context, {
      "codigo": code,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: _onDetect,
      ),
    );
  }
}
