import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class EscanerPantalla extends StatefulWidget {
  const EscanerPantalla({super.key});

  @override
  State<EscanerPantalla> createState() => _EscanerPantallaState();
}

class _EscanerPantallaState extends State<EscanerPantalla> {
  bool escaneado = false;

  void onDetect(BarcodeCapture capture) {
    if (escaneado) return;

    final code = capture.barcodes.first.rawValue;
    if (code != null && code.isNotEmpty) {
      escaneado = true;
      Navigator.pop(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear Código")),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: onDetect,
      ),
    );
  }
}
