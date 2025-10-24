import 'package:cloud_firestore/cloud_firestore.dart';
import '../modelos/concurso.dart';
import '../modelos/categoria.dart';
import 'servicio_autenticacion.dart';

class ServicioConcursos {
  static final ServicioConcursos _instancia = ServicioConcursos._interno();
  factory ServicioConcursos() => _instancia;
  ServicioConcursos._interno();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Concurso> _concursosRef =
      _firestore.collection('concursos').withConverter<Concurso>(
            fromFirestore: (snapshots, _) => Concurso.fromFirestore(snapshots.data()!),
            toFirestore: (concurso, _) => concurso.toFirestore(),
          );

  Future<bool> crearConcurso({
    required String nombre,
    required List<Categoria> categorias,
    required DateTime fechaLimiteInscripcion,
    required DateTime fechaRevision,
    required DateTime fechaConfirmacionAceptados,
  }) async {
    final servicioAuth = ServicioAutenticacion();
    if (!servicioAuth.estaAutenticado) {
      return false;
    }

    try {
      final nuevoConcurso = Concurso(
        id: _firestore.collection('concursos').doc().id, // Generar ID único
        nombre: nombre,
        categorias: categorias,
        fechaLimiteInscripcion: fechaLimiteInscripcion,
        fechaRevision: fechaRevision,
        fechaConfirmacionAceptados: fechaConfirmacionAceptados,
        fechaCreacion: DateTime.now(),
        administradorId: servicioAuth.administradorActual!.id,
      );

      await _concursosRef.doc(nuevoConcurso.id).set(nuevoConcurso);
      return true;
    } catch (e) {
      print('Error al crear concurso: $e');
      return false;
    }
  }

  Stream<List<Concurso>> obtenerConcursosDelAdministrador() {
    final servicioAuth = ServicioAutenticacion();
    final adminId = servicioAuth.administradorActual?.id;

    if (!servicioAuth.estaAutenticado || adminId == null) {
      return Stream.value([]);
    }

    return _concursosRef
        .where('administradorId', isEqualTo: adminId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<bool> actualizarConcurso({
    required String concursoId,
    required String nombre,
    required List<Categoria> categorias,
    required DateTime fechaLimiteInscripcion,
    required DateTime fechaRevision,
    required DateTime fechaConfirmacionAceptados,
  }) async {
    final servicioAuth = ServicioAutenticacion();
    if (!servicioAuth.estaAutenticado) {
      return false;
    }

    try {
      // Primero, obtenemos el concurso para asegurarnos de que pertenece al admin actual
      final doc = await _concursosRef.doc(concursoId).get();
      if (!doc.exists || doc.data()!.administradorId != servicioAuth.administradorActual!.id) {
        return false; // El concurso no existe o no pertenece al administrador
      }

      final concursoActualizado = {
        'nombre': nombre,
        'categorias': categorias.map((c) => c.toMap()).toList(),
        'fechaLimiteInscripcion': Timestamp.fromDate(fechaLimiteInscripcion),
        'fechaRevision': Timestamp.fromDate(fechaRevision),
        'fechaConfirmacionAceptados': Timestamp.fromDate(fechaConfirmacionAceptados),
      };

      await _concursosRef.doc(concursoId).update(concursoActualizado);
      return true;
    } catch (e) {
      print('Error al actualizar concurso: $e');
      return false;
    }
  }

  Future<bool> eliminarConcurso(String concursoId) async {
    final servicioAuth = ServicioAutenticacion();
    if (!servicioAuth.estaAutenticado) {
      return false;
    }

    try {
      // Opcional: Verificar que el concurso pertenece al admin antes de borrar
      final doc = await _concursosRef.doc(concursoId).get();
      if (!doc.exists || doc.data()!.administradorId != servicioAuth.administradorActual!.id) {
        return false;
      }

      await _concursosRef.doc(concursoId).delete();
      return true;
    } catch (e) {
      print('Error al eliminar concurso: $e');
      return false;
    }
  }
}