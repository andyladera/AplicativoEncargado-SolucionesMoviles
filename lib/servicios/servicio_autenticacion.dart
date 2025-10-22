import '../modelos/administrador.dart';

class ServicioAutenticacion {
  static final ServicioAutenticacion _instancia = ServicioAutenticacion._interno();
  factory ServicioAutenticacion() => _instancia;
  ServicioAutenticacion._interno();

  Administrador? _administradorActual;
  Administrador? get administradorActual => _administradorActual;

  // Lista temporal de administradores registrados (más adelante se conectará a la BD)
  final List<Administrador> _administradoresRegistrados = [
    // Usuario administrador predeterminado para pruebas
    Administrador(
      id: 'admin-001',
      nombres: 'Administrador',
      apellidos: 'EPIS',
      correo: 'admin@gmail.com',
      numeroTelefonico: '999999999',
    ),
  ];

  Future<bool> registrarAdministrador({
    required String nombres,
    required String apellidos,
    required String correo,
    required String numeroTelefonico,
    required String contrasena,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    // Verificar si el correo ya existe
    if (_administradoresRegistrados.any((admin) => admin.correo == correo)) {
      return false;
    }

    final nuevoAdmin = Administrador(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombres: nombres,
      apellidos: apellidos,
      correo: correo,
      numeroTelefonico: numeroTelefonico,
    );

    _administradoresRegistrados.add(nuevoAdmin);
    return true;
  }

  Future<bool> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    final admin = _administradoresRegistrados
        .where((admin) => admin.correo == correo)
        .firstOrNull;

    if (admin != null) {
      // Para el usuario de prueba admin@gmail.com, verificar contraseña "admin"
      if (correo == 'admin@gmail.com' && contrasena != 'admin') {
        return false;
      }
      // Para otros usuarios, por simplicidad aceptamos cualquier contraseña en esta versión de prueba
      _administradorActual = admin;
      return true;
    }

    return false;
  }

  void cerrarSesion() {
    _administradorActual = null;
  }

  bool get estaAutenticado => _administradorActual != null;
}