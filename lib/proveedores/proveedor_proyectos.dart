import 'dart:async';

import 'package:flutter/foundation.dart';
import '../modelos/proyecto.dart';
import '../servicios/servicio_proyectos.dart';

class ProveedorProyectos extends ChangeNotifier {
  final ServicioProyectos _servicioProyectos = ServicioProyectos();
  StreamSubscription<List<Proyecto>>? _proyectosSubscription;

  List<Proyecto> _proyectos = [];
  List<Proyecto> get proyectos => List.unmodifiable(_proyectos);

  Map<EstadoProyecto, int> _estadisticas = {};
  Map<EstadoProyecto, int> get estadisticas => Map.unmodifiable(_estadisticas);

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _mensajeError;
  String? get mensajeError => _mensajeError;

  String? _concursoActual;
  String? get concursoActual => _concursoActual;

  void escucharProyectosPorConcurso(String concursoId) {
    _cargando = true;
    _mensajeError = null;
    _concursoActual = concursoId;
    notifyListeners();

    _proyectosSubscription?.cancel();
    _proyectosSubscription = _servicioProyectos.obtenerProyectosPorConcurso(concursoId).listen((proyectos) {
      _proyectos = proyectos;
      _actualizarEstadisticas();
      _cargando = false;
      notifyListeners();
    }, onError: (error) {
      _mensajeError = 'Error al cargar los proyectos';
      _cargando = false;
      notifyListeners();
    });
  }

  void _actualizarEstadisticas() {
    _estadisticas = {};
    for (var proyecto in _proyectos) {
      _estadisticas.update(proyecto.estado, (value) => value + 1, ifAbsent: () => 1);
    }
  }

  Future<bool> actualizarEstadoProyecto(String proyectoId, EstadoProyecto nuevoEstado, {String? comentarios, double? puntuacion}) async {
    try {
      await _servicioProyectos.actualizarEstadoProyecto(
        proyectoId, 
        nuevoEstado, 
        comentarios: comentarios, 
        puntuacion: puntuacion
      );      
      return true;
    } catch (e) {
      _mensajeError = 'Error al actualizar el estado del proyecto';
      notifyListeners();
      return false;
    }
  }

  List<Proyecto> filtrarPorEstado(EstadoProyecto estado) {
    return _proyectos.where((proyecto) => proyecto.estado == estado).toList();
  }

  List<Proyecto> filtrarPorCategoria(String categoria) {
    return _proyectos.where((proyecto) => proyecto.categoriaId == categoria).toList();
  }

  void limpiarError() {
    _mensajeError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _proyectosSubscription?.cancel();
    super.dispose();
  }

  void limpiar() {
    _proyectosSubscription?.cancel();
    _proyectos.clear();
    _estadisticas.clear();
    _concursoActual = null;
    _mensajeError = null;
    _cargando = false;
    notifyListeners();
  }
}