import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../widgets/selector_cliente.dart';
import '../widgets/scaner_codigo.dart';
import '../widgets/gps_widget.dart';
import '../models/cliente.dart';

class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  Cliente? cliente;
  String? codigo;
  Position? posicion;

  void _guardarFormulario() {
    if (codigo == null || posicion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos antes de continuar.")),
      );
      return;
    }

    // Aquí podés enviar los datos, guardarlos o mostrarlos
    print("Cliente: ${cliente!.nombre}");
    print("Código: $codigo");
    print("GPS: ${posicion!.latitude}, ${posicion!.longitude} (±${posicion!.accuracy} m)");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Formulario enviado correctamente.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Formulario de Verificación")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SelectorCliente(
              onSelected: (c) => setState(() => cliente = c),
            ),
            const SizedBox(height: 16),
            EscanerCodigo(
              onScan: (c) => setState(() => codigo = c),
            ),
            const SizedBox(height: 16),
            GpsWidget(
              onLocation: (p) => setState(() => posicion = p),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _guardarFormulario,
              icon: const Icon(Icons.check),
              label: const Text("Confirmar / Guardar"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
