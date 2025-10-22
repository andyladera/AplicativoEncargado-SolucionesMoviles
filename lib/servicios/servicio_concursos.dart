import '../modelos/concurso.dart';
import '../modelos/categoria.dart';
import 'servicio_autenticacion.dart';

class ServicioConcursos {
  static final ServicioConcursos _instancia = ServicioConcursos._interno();
  factory ServicioConcursos() => _instancia;
  ServicioConcursos._interno();

  // Lista temporal de concursos (más adelante se conectará a la BD)
  final List<Concurso> _concursos = [
    // Concurso de ejemplo para mostrar funcionalidades
    Concurso(
      id: 'ejemplo-001',
      nombre: 'Concurso de Proyectos EPIS 2024',
      categorias: [
        Categoria(nombre: 'Categoria Junior', rangoCiclos: 'I a III ciclo'),
        Categoria(nombre: 'Categoria Intermedio', rangoCiclos: 'IV a VI ciclo'),
        Categoria(nombre: 'Categoria Senior', rangoCiclos: 'VII a X ciclo'),
      ],
      fechaLimiteInscripcion: DateTime.now().add(const Duration(days: 30)),
      fechaRevision: DateTime.now().add(const Duration(days: 45)),
      fechaConfirmacionAceptados: DateTime.now().add(const Duration(days: 60)),
      fechaCreacion: DateTime.now().subtract(const Duration(days: 5)),
      administradorId: 'admin-001',
    ),
  ];

  List<Concurso> get concursos => List.unmodifiable(_concursos);

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

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    final nuevoConcurso = Concurso(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre,
      categorias: categorias,
      fechaLimiteInscripcion: fechaLimiteInscripcion,
      fechaRevision: fechaRevision,
      fechaConfirmacionAceptados: fechaConfirmacionAceptados,
      fechaCreacion: DateTime.now(),
      administradorId: servicioAuth.administradorActual!.id,
    );

    _concursos.add(nuevoConcurso);
    return true;
  }

  Future<List<Concurso>> obtenerConcursos() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_concursos);
  }

  Future<List<Concurso>> obtenerConcursosDelAdministrador() async {
    final servicioAuth = ServicioAutenticacion();
    
    if (!servicioAuth.estaAutenticado) {
      return [];
    }

    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _concursos
        .where((concurso) => concurso.administradorId == servicioAuth.administradorActual!.id)
        .toList();
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

    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    final indice = _concursos.indexWhere((concurso) => 
        concurso.id == concursoId && 
        concurso.administradorId == servicioAuth.administradorActual!.id);

    if (indice != -1) {
      final concursoOriginal = _concursos[indice];
      _concursos[indice] = Concurso(
        id: concursoOriginal.id,
        nombre: nombre,
        categorias: categorias,
        fechaLimiteInscripcion: fechaLimiteInscripcion,
        fechaRevision: fechaRevision,
        fechaConfirmacionAceptados: fechaConfirmacionAceptados,
        fechaCreacion: concursoOriginal.fechaCreacion,
        administradorId: concursoOriginal.administradorId,
      );
      return true;
    }

    return false;
  }

  Future<bool> eliminarConcurso(String concursoId) async {
    final servicioAuth = ServicioAutenticacion();
    
    if (!servicioAuth.estaAutenticado) {
      return false;
    }

    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    final indice = _concursos.indexWhere((concurso) => 
        concurso.id == concursoId && 
        concurso.administradorId == servicioAuth.administradorActual!.id);

    if (indice != -1) {
      _concursos.removeAt(indice);
      return true;
    }

    return false;
  }
}