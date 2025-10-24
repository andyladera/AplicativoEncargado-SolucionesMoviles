import 'dart:async';
import 'package:flutter/foundation.dart';
import '../modelos/concurso.dart';
import '../modelos/categoria.dart';
import '../servicios/servicio_concursos.dart';

enum EstadoCarga {
  cargando,
  listo,
  error,
}

class ProveedorConcursos extends ChangeNotifier {
  final ServicioConcursos _servicioConcursos = ServicioConcursos();
  List<Concurso> _concursos = [];
  EstadoCarga _estado = EstadoCarga.cargando;
  StreamSubscription? _concursosSubscription;

  List<Concurso> get concursos => _concursos;
  EstadoCarga get estado => _estado;

  ProveedorConcursos() {
    _escucharConcursos();
  }

  void _escucharConcursos() {
    _estado = EstadoCarga.cargando;
    notifyListeners();

    _concursosSubscription?.cancel();
    _concursosSubscription = _servicioConcursos.obtenerConcursosDelAdministrador().listen((concursos) {
      _concursos = concursos;
      _estado = EstadoCarga.listo;
      notifyListeners();
    }, onError: (error) {
      _estado = EstadoCarga.error;
      notifyListeners();
      print("Error al escuchar concursos: $error");
    });
  }

  Future<bool> crearConcurso({
    required String nombre,
    required List<Categoria> categorias,
    required DateTime fechaLimiteInscripcion,
    required DateTime fechaRevision,
    required DateTime fechaConfirmacionAceptados,
  }) async {
    final resultado = await _servicioConcursos.crearConcurso(
      nombre: nombre,
      categorias: categorias,
      fechaLimiteInscripcion: fechaLimiteInscripcion,
      fechaRevision: fechaRevision,
      fechaConfirmacionAceptados: fechaConfirmacionAceptados,
    );
    // No es necesario notificar, el stream lo hará automáticamente
    return resultado;
  }

  Future<bool> actualizarConcurso({
    required String concursoId,
    required String nombre,
    required List<Categoria> categorias,
    required DateTime fechaLimiteInscripcion,
    required DateTime fechaRevision,
    required DateTime fechaConfirmacionAceptados,
  }) async {
    return await _servicioConcursos.actualizarConcurso(
      concursoId: concursoId,
      nombre: nombre,
      categorias: categorias,
      fechaLimiteInscripcion: fechaLimiteInscripcion,
      fechaRevision: fechaRevision,
      fechaConfirmacionAceptados: fechaConfirmacionAceptados,
    );
  }

  Future<void> eliminarConcurso(String concursoId) async {
    await _servicioConcursos.eliminarConcurso(concursoId);
    // El stream actualizará la lista
  }

  @override
  void dispose() {
    _concursosSubscription?.cancel();
    super.dispose();
  }
}