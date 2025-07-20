import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cliente.dart';

class SelectorCliente extends StatelessWidget {
  final void Function(Cliente) onSelected;

  const SelectorCliente({super.key, required this.onSelected});

  Future<List<Cliente>> _fetchClientes(String filtro) async {
    try {
      final response = await http.get(
        Uri.parse("https://tuservidor.com/api/clientes?search=$filtro"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Cliente.fromJson(e)).toList();
      } else {
        throw Exception("Error al cargar clientes");
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<Cliente>(
      asyncItems: (filtro) => _fetchClientes(filtro),
      itemAsString: (cliente) => cliente.nombre,
      onChanged: (cliente) {
        if (cliente != null) {
          onSelected(cliente);
        }
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Seleccionar Cliente",
          hintText: "Buscar por nombre o RUC",
        ),
      ),
      popupProps: const PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(labelText: "Buscar..."),
        ),
      ),
    );
  }
}
