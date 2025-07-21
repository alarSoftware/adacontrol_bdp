import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'scanner_page.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdaControl BDP',
      debugShowCheckedModeBanner: false,
      home: const WebViewScreen(),
    );
  }
}

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
          final action = message.message;

          if (action == "escanear") {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ScannerPage()),
            );

            if (result != null && result is Map && result['codigo'] != null) {
              final code = result['codigo'];
              _controller.runJavaScript(
                  "document.getElementById('codigo').value = '$code';"
              );
            }
          }

          if (action == "gps") {
            _controller.runJavaScript('''
    document.getElementById('estado-gps').innerText = 'Obteniendo ubicación...';
  ''');

            final pos = await obtenerPosicionPrecisa();

            if (pos != null) {
              _controller.runJavaScript('''
      document.getElementById('gps').value = '${pos.latitude},${pos.longitude}';
      document.getElementById('precision').value = '${pos.accuracy.toStringAsFixed(1)} m';
      document.getElementById('estado-gps').innerText = 'Ubicación obtenida: ${pos.latitude}, ${pos.longitude}';
    ''');
            } else {
              _controller.runJavaScript('''
      document.getElementById('estado-gps').innerText = 'No se pudo obtener la ubicación.';
    ''');
            }
          }
        },
      )
      ..loadRequest(
        Uri.parse('http://192.168.3.213:8812/reportes/ventas'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: _controller)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.reload();
        },
        child: const Icon(Icons.refresh),
        tooltip: 'Recargar página',
      ),
    );
  }
}



Future<Position?> obtenerPosicionPrecisa() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return null;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return null;
  }

  if (permission == LocationPermission.deniedForever) return null;

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  );
}