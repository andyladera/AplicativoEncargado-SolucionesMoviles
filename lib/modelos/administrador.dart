class Administrador {
  final String id;
  final String nombres;
  final String apellidos;
  final String correo;
  final String numeroTelefonico;

  Administrador({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.numeroTelefonico,
  });

  Map<String, dynamic> aJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'numeroTelefonico': numeroTelefonico,
    };
  }

  static Administrador desdeJson(Map<String, dynamic> json) {
    return Administrador(
      id: json['id'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      correo: json['correo'],
      numeroTelefonico: json['numeroTelefonico'],
    );
  }

  String get nombreCompleto => '$nombres $apellidos';
}