import 'package:flutter/foundation.dart';
import '../modelos/proyecto.dart';
import '../servicios/servicio_proyectos.dart';

class ProveedorProyectos extends ChangeNotifier {
  final ServicioProyectos _servicioProyectos = ServicioProyectos();

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

  Future<void> cargarProyectosPorConcurso(String concursoId) async {
    _cargando = true;
    _mensajeError = null;
    _concursoActual = concursoId;
    notifyListeners();

    try {
      _proyectos = await _servicioProyectos.obtenerProyectosPorConcurso(concursoId);
      _estadisticas = _servicioProyectos.obtenerEstadisticasPorConcurso(concursoId);
      _cargando = false;
      notifyListeners();
    } catch (e) {
      _mensajeError = 'Error al cargar los proyectos';
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarProyectosPorCategoria(String concursoId, String categoria) async {
    _cargando = true;
    _mensajeError = null;
    notifyListeners();

    try {
      _proyectos = await _servicioProyectos.obtenerProyectosPorCategoria(concursoId, categoria);
      _cargando = false;
      notifyListeners();
    } catch (e) {
      _mensajeError = 'Error al cargar los proyectos de la categoria';
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarEstadoProyecto(String proyectoId, EstadoProyecto nuevoEstado, {String? comentarios, double? puntuacion}) async {
    try {
      final exito = await _servicioProyectos.actualizarEstadoProyecto(
        proyectoId, 
        nuevoEstado, 
        comentarios: comentarios, 
        puntuacion: puntuacion
      );
      
      if (exito && _concursoActual != null) {
        // Recargar proyectos para mostrar cambios
        await cargarProyectosPorConcurso(_concursoActual!);
      }
      
      return exito;
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

  void limpiar() {
    _proyectos.clear();
    _estadisticas.clear();
    _concursoActual = null;
    _mensajeError = null;
    _cargando = false;
    notifyListeners();
  }
}