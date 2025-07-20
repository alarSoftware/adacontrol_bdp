import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsWidget extends StatefulWidget {
  final void Function(Position) onLocation;

  const GpsWidget({super.key, required this.onLocation});

  @override
  State<GpsWidget> createState() => _GpsWidgetState();
}

class _GpsWidgetState extends State<GpsWidget> {
  Position? _position;
  bool _cargando = false;
  String? _error;

  Future<void> _obtenerUbicacion() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw "Ubicación deshabilitada";
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) throw "Permiso denegado";
      }

      if (permission == LocationPermission.deniedForever) {
        throw "Permiso de ubicación denegado permanentemente";
      }

      final posicion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      setState(() {
        _position = posicion;
        _cargando = false;
      });

      widget.onLocation(posicion);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ubicación GPS", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: _position != null
                      ? "${_position!.latitude.toStringAsFixed(6)}, ${_position!.longitude.toStringAsFixed(6)}"
                      : _error ?? '',
                ),
                decoration: const InputDecoration(
                  hintText: "Sin ubicación",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _cargando ? null : _obtenerUbicacion,
              icon: const Icon(Icons.my_location),
              label: _cargando
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text("Obtener"),
            ),
          ],
        ),
        if (_position != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "Precisión: ±${_position!.accuracy.toStringAsFixed(1)} m",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
