import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'escaner_pantalla.dart';

class EscanerCodigo extends StatefulWidget {
  final void Function(String) onScan;

  const EscanerCodigo({super.key, required this.onScan});

  @override
  State<EscanerCodigo> createState() => _EscanerCodigoState();
}

class _EscanerCodigoState extends State<EscanerCodigo> {
  String? codigo;

  void abrirEscaner() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const EscanerPantalla(),
      ),
    );

    if (result != null) {
      setState(() {
        codigo = result;
      });
      widget.onScan(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Código Escaneado", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(text: codigo),
                decoration: const InputDecoration(
                  hintText: "Sin escanear",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: abrirEscaner,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text("Escanear"),
            )
          ],
        ),
      ],
    );
  }
}
