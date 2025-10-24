class Categoria {
  final String nombre;
  final String rangoCiclos;

  Categoria({required this.nombre, required this.rangoCiclos});

  factory Categoria.fromMap(Map<String, dynamic> data) {
    return Categoria(
      nombre: data['nombre'] as String,
      rangoCiclos: data['rangoCiclos'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'rangoCiclos': rangoCiclos,
    };
  }
}