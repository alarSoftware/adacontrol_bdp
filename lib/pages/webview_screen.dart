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
      ..loadRequest(
        Uri.parse('https://2cad7a147326.ngrok-free.app'), // Tu URL
      );
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
