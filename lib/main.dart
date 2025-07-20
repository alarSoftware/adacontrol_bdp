import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'scanner_page.dart';
import 'pages/formulario_page.dart';         // ✅ nueva pantalla nativa
import 'pages/webview_screen.dart';         // ✅ extraído el WebView aquí

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
      initialRoute: '/',
      routes: {
        '/': (_) => const WebViewScreen(),         // ✅ pantalla principal
        '/formulario': (_) => const FormularioPage(), // ✅ nueva pantalla
      },
    );
  }
}
