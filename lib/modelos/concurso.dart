import 'package:cloud_firestore/cloud_firestore.dart';

import 'categoria.dart';

class Concurso {
  final String id;
  final String nombre;
  final List<Categoria> categorias;
  final DateTime fechaLimiteInscripcion;
  final DateTime fechaRevision;
  final DateTime fechaConfirmacionAceptados;
  final DateTime fechaCreacion;
  final String administradorId;

  Concurso({
    required this.id,
    required this.nombre,
    required this.categorias,
    required this.fechaLimiteInscripcion,
    required this.fechaRevision,
    required this.fechaConfirmacionAceptados,
    required this.fechaCreacion,
    required this.administradorId,
  });

  factory Concurso.fromFirestore(Map<String, dynamic> data) {
    return Concurso(
      id: data['id'] as String,
      nombre: data['nombre'] as String,
      categorias: (data['categorias'] as List<dynamic>)
          .map((e) => Categoria.fromMap(e as Map<String, dynamic>))
          .toList(),
      fechaLimiteInscripcion:
          (data['fechaLimiteInscripcion'] as Timestamp).toDate(),
      fechaRevision: (data['fechaRevision'] as Timestamp).toDate(),
      fechaConfirmacionAceptados:
          (data['fechaConfirmacionAceptados'] as Timestamp).toDate(),
      fechaCreacion: (data['fechaCreacion'] as Timestamp).toDate(),
      administradorId: data['administradorId'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nombre': nombre,
      'categorias': categorias.map((e) => e.toMap()).toList(),
      'fechaLimiteInscripcion': Timestamp.fromDate(fechaLimiteInscripcion),
      'fechaRevision': Timestamp.fromDate(fechaRevision),
      'fechaConfirmacionAceptados':
          Timestamp.fromDate(fechaConfirmacionAceptados),
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'administradorId': administradorId,
    };
  }


  bool get estaVigente {
    return DateTime.now().isBefore(fechaLimiteInscripcion);
  }

  String get estadoConcurso {
    final ahora = DateTime.now();
    if (ahora.isBefore(fechaLimiteInscripcion)) {
      return 'Inscripciones abiertas';
    } else if (ahora.isBefore(fechaRevision)) {
      return 'En proceso de revision';
    } else if (ahora.isBefore(fechaConfirmacionAceptados)) {
      return 'Revision completada';
    } else {
      return 'Finalizado';
    }
  }
}