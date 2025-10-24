import 'package:cloud_firestore/cloud_firestore.dart';

class Proyecto {
  final String id;
  final String nombre;
  final String linkGithub;
  final String archivoZip; // URL o path del archivo ZIP
  final String estudianteId;
  final String nombreEstudiante;
  final String correoEstudiante;
  final String concursoId;
  final String categoriaId;
  final DateTime fechaEnvio;
  final EstadoProyecto estado;
  final String? comentarios;
  final double? puntuacion;

  Proyecto({
    required this.id,
    required this.nombre,
    required this.linkGithub,
    required this.archivoZip,
    required this.estudianteId,
    required this.nombreEstudiante,
    required this.correoEstudiante,
    required this.concursoId,
    required this.categoriaId,
    required this.fechaEnvio,
    required this.estado,
    this.comentarios,
    this.puntuacion,
  });

  factory Proyecto.fromFirestore(Map<String, dynamic> data) {
    return Proyecto(
      id: data['id'],
      nombre: data['nombre'],
      linkGithub: data['linkGithub'],
      archivoZip: data['archivoZip'],
      estudianteId: data['estudianteId'],
      nombreEstudiante: data['nombreEstudiante'],
      correoEstudiante: data['correoEstudiante'],
      concursoId: data['concursoId'],
      categoriaId: data['categoriaId'],
      fechaEnvio: (data['fechaEnvio'] as Timestamp).toDate(),
      estado: EstadoProyecto.values.byName(data['estado']),
      comentarios: data['comentarios'],
      puntuacion: data['puntuacion']?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nombre': nombre,
      'linkGithub': linkGithub,
      'archivoZip': archivoZip,
      'estudianteId': estudianteId,
      'nombreEstudiante': nombreEstudiante,
      'correoEstudiante': correoEstudiante,
      'concursoId': concursoId,
      'categoriaId': categoriaId,
      'fechaEnvio': Timestamp.fromDate(fechaEnvio),
      'estado': estado.name,
      'comentarios': comentarios,
      'puntuacion': puntuacion,
    };
  }

  String get estadoTexto {
    switch (estado) {
      case EstadoProyecto.enviado:
        return 'Enviado';
      case EstadoProyecto.enRevision:
        return 'En Revisión';
      case EstadoProyecto.aprobado:
        return 'Aprobado';
      case EstadoProyecto.rechazado:
        return 'Rechazado';
      case EstadoProyecto.ganador:
        return 'Ganador';
    }
  }
}

enum EstadoProyecto {
  enviado,
  enRevision,
  aprobado,
  rechazado,
  ganador,
}