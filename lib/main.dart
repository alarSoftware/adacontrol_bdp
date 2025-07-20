import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'scanner_page.dart';

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
          final scannedCode = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScannerPage(),
            ),
          );

          if (scannedCode != null) {
            _controller.runJavaScript(
              "document.getElementById('codigo').value = '$scannedCode';",
            );
          }
        },
      )
      ..loadRequest(
        Uri.parse('https://c42441bcbc86.ngrok-free.app/reportes/ventas'),
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
