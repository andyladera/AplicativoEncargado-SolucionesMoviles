import '../modelos/proyecto.dart';
import 'servicio_autenticacion.dart';

class ServicioProyectos {
  static final ServicioProyectos _instancia = ServicioProyectos._interno();
  factory ServicioProyectos() => _instancia;
  ServicioProyectos._interno();

  // Lista temporal de proyectos (más adelante se conectará a la BD)
  final List<Proyecto> _proyectos = [
    // Proyectos de ejemplo para demostrar funcionalidad
    Proyecto(
      id: 'proyecto-001',
      nombre: 'Sistema de Gestión Académica',
      linkGithub: 'https://github.com/estudiante1/sistema-academico',
      archivoZip: 'sistema-academico.zip',
      estudianteId: 'est-001',
      nombreEstudiante: 'Juan Carlos Pérez',
      correoEstudiante: 'juan.perez@estudiante.edu.pe',
      concursoId: 'ejemplo-001',
      categoriaId: 'Categoria Senior',
      fechaEnvio: DateTime.now().subtract(const Duration(days: 3)),
      estado: EstadoProyecto.enviado,
    ),
    Proyecto(
      id: 'proyecto-002',
      nombre: 'App de Reservas Móvil',
      linkGithub: 'https://github.com/estudiante2/app-reservas',
      archivoZip: 'app-reservas.zip',
      estudianteId: 'est-002',
      nombreEstudiante: 'María Elena García',
      correoEstudiante: 'maria.garcia@estudiante.edu.pe',
      concursoId: 'ejemplo-001',
      categoriaId: 'Categoria Intermedio',
      fechaEnvio: DateTime.now().subtract(const Duration(days: 2)),
      estado: EstadoProyecto.enRevision,
    ),
    Proyecto(
      id: 'proyecto-003',
      nombre: 'Plataforma de E-learning',
      linkGithub: 'https://github.com/estudiante3/e-learning',
      archivoZip: 'e-learning-platform.zip',
      estudianteId: 'est-003',
      nombreEstudiante: 'Carlos Alberto Ruiz',
      correoEstudiante: 'carlos.ruiz@estudiante.edu.pe',
      concursoId: 'ejemplo-001',
      categoriaId: 'Categoria Senior',
      fechaEnvio: DateTime.now().subtract(const Duration(days: 1)),
      estado: EstadoProyecto.aprobado,
    ),
    Proyecto(
      id: 'proyecto-004',
      nombre: 'Sistema de Inventario',
      linkGithub: 'https://github.com/estudiante4/inventario',
      archivoZip: 'sistema-inventario.zip',
      estudianteId: 'est-004',
      nombreEstudiante: 'Ana Sofía López',
      correoEstudiante: 'ana.lopez@estudiante.edu.pe',
      concursoId: 'ejemplo-001',
      categoriaId: 'Categoria Junior',
      fechaEnvio: DateTime.now().subtract(const Duration(hours: 12)),
      estado: EstadoProyecto.ganador,
    ),
  ];

  List<Proyecto> get proyectos => List.unmodifiable(_proyectos);

  Future<List<Proyecto>> obtenerProyectosPorConcurso(String concursoId) async {
    final servicioAuth = ServicioAutenticacion();
    
    if (!servicioAuth.estaAutenticado) {
      return [];
    }

    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    
    return _proyectos
        .where((proyecto) => proyecto.concursoId == concursoId)
        .toList()
      ..sort((a, b) => b.fechaEnvio.compareTo(a.fechaEnvio)); // Más recientes primero
  }

  Future<List<Proyecto>> obtenerProyectosPorCategoria(String concursoId, String categoria) async {
    final servicioAuth = ServicioAutenticacion();
    
    if (!servicioAuth.estaAutenticado) {
      return [];
    }

    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    
    return _proyectos
        .where((proyecto) => 
            proyecto.concursoId == concursoId && 
            proyecto.categoriaId == categoria)
        .toList()
      ..sort((a, b) => b.fechaEnvio.compareTo(a.fechaEnvio));
  }

  Future<bool> actualizarEstadoProyecto(String proyectoId, EstadoProyecto nuevoEstado, {String? comentarios, double? puntuacion}) async {
    final servicioAuth = ServicioAutenticacion();
    
    if (!servicioAuth.estaAutenticado) {
      return false;
    }

    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    final indice = _proyectos.indexWhere((proyecto) => proyecto.id == proyectoId);

    if (indice != -1) {
      final proyectoOriginal = _proyectos[indice];
      _proyectos[indice] = Proyecto(
        id: proyectoOriginal.id,
        nombre: proyectoOriginal.nombre,
        linkGithub: proyectoOriginal.linkGithub,
        archivoZip: proyectoOriginal.archivoZip,
        estudianteId: proyectoOriginal.estudianteId,
        nombreEstudiante: proyectoOriginal.nombreEstudiante,
        correoEstudiante: proyectoOriginal.correoEstudiante,
        concursoId: proyectoOriginal.concursoId,
        categoriaId: proyectoOriginal.categoriaId,
        fechaEnvio: proyectoOriginal.fechaEnvio,
        estado: nuevoEstado,
        comentarios: comentarios ?? proyectoOriginal.comentarios,
        puntuacion: puntuacion ?? proyectoOriginal.puntuacion,
      );
      return true;
    }

    return false;
  }

  Map<EstadoProyecto, int> obtenerEstadisticasPorConcurso(String concursoId) {
    final proyectosConcurso = _proyectos.where((p) => p.concursoId == concursoId);
    
    final estadisticas = <EstadoProyecto, int>{};
    for (final estado in EstadoProyecto.values) {
      estadisticas[estado] = proyectosConcurso.where((p) => p.estado == estado).length;
    }
    
    return estadisticas;
  }
}