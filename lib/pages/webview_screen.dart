import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterChannel',
        onMessageReceived: (JavaScriptMessage message) async {
          final data = message.message;

          if (data == 'gps') {
            final position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            final lat = position.latitude;
            final lon = position.longitude;
            final accuracy = position.accuracy;

            // Llama a JS con los datos de ubicación
            _controller.runJavaScript('''
              document.getElementById("gps").value = "$lat, $lon";
              document.getElementById("precision").value = "$accuracy m";
              document.getElementById("estado-gps").innerText = "Ubicación actualizada: $lat, $lon (±$accuracy m)";
          ''');
          }

          if (data == 'escanear') {
            // Simulación o implementación real con código de barras
            const codigo = "ABC123"; // Reemplazá por tu lógica de escaneo real
            _controller.runJavaScript('''
              document.getElementById("codigo").value = "$codigo";
              document.getElementById("cd").innerText = "Código: $codigo";
          ''');
          }
        },
      )
      ..loadRequest(Uri.parse('http://192.168.3.213:8812/reportes/compras'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AdaControl BDP"),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'formulario',
            onPressed: () {
              Navigator.pushNamed(context, '/formulario');
            },
            icon: const Icon(Icons.article),
            label: const Text("Formulario"),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'reload',
            onPressed: () {
              _controller.reload();
            },
            child: const Icon(Icons.refresh),
            tooltip: 'Recargar Web',
          ),
        ],
      ),
    );
  }
}
