// El enum se define aquí para que todo sea consistente.
enum EstadoProyecto {
  enviado,
  enRevision,
  aprobado,
  rechazado,
  ganador,
}

class Proyecto {
  final String id;
  final String nombre;
  final String linkGithub;
  final String archivoZip;
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
}