import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/proyecto.dart';
import 'servicio_autenticacion.dart';

class ServicioProyectos {
  static final ServicioProyectos _instancia = ServicioProyectos._interno();
  factory ServicioProyectos() => _instancia;
  ServicioProyectos._interno();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Proyecto> _proyectosRef =
      _firestore.collection('proyectos').withConverter<Proyecto>(
            fromFirestore: (snapshots, _) => Proyecto.fromFirestore(snapshots.data()!),
            toFirestore: (proyecto, _) => proyecto.toFirestore(),
          );

  Stream<List<Proyecto>> obtenerProyectosPorConcurso(String concursoId) {
    final servicioAuth = ServicioAutenticacion();
    if (!servicioAuth.estaAutenticado) {
      return Stream.value([]);
    }

    return _proyectosRef
        .where('concursoId', isEqualTo: concursoId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList()
          ..sort((a, b) => b.fechaEnvio.compareTo(a.fechaEnvio)));
  }

  Future<bool> actualizarEstadoProyecto(
    String proyectoId,
    EstadoProyecto nuevoEstado, {
    String? comentarios,
    double? puntuacion,
  }) async {
    final servicioAuth = ServicioAutenticacion();
    if (!servicioAuth.estaAutenticado) {
      return false;
    }

    try {
      final updateData = {
        'estado': nuevoEstado.name,
        'comentarios': comentarios,
        'puntuacion': puntuacion,
      };

      // Eliminar claves nulas para no sobrescribir con null en Firestore
      updateData.removeWhere((key, value) => value == null);

      await _proyectosRef.doc(proyectoId).update(updateData);
      return true;
    } catch (e) {
      print('Error al actualizar estado del proyecto: $e');
      return false;
    }
  }

  Stream<Map<EstadoProyecto, int>> obtenerEstadisticasPorConcurso(String concursoId) {
    return obtenerProyectosPorConcurso(concursoId).map((proyectos) {
      final estadisticas = <EstadoProyecto, int>{};
      for (final estado in EstadoProyecto.values) {
        estadisticas[estado] = proyectos.where((p) => p.estado == estado).length;
      }
      return estadisticas;
    });
  }
}