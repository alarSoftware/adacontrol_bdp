class Cliente {
  final int id;
  final String nombre;

  Cliente({required this.id, required this.nombre});

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  @override
  String toString() => nombre;
}
