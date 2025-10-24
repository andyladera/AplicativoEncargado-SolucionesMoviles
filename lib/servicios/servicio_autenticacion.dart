import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../modelos/administrador.dart';

class ServicioAutenticacion {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Administrador? _administradorActual;
  static Administrador? get administradorActual => _administradorActual;

  Future<bool> registrarAdministrador({
    required String nombres,
    required String apellidos,
    required String correo,
    required String numeroTelefonico,
    required String contrasena,
  }) async {
    try {
      // Crear usuario en Firebase Authentication
      final credenciales = await _firebaseAuth.createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      if (credenciales.user != null) {
        // Guardar datos adicionales en Firestore
        final nuevoAdmin = Administrador(
          id: credenciales.user!.uid,
          nombres: nombres,
          apellidos: apellidos,
          correo: correo,
          numeroTelefonico: numeroTelefonico,
        );
        await _firestore
            .collection('administradores')
            .doc(credenciales.user!.uid)
            .set(nuevoAdmin.aJson());
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      // Manejar errores, por ejemplo, si el correo ya existe
      print('Error en el registro: ${e.message}');
      return false;
    } on FirebaseAuthException catch (e) {
      // Manejar errores, por ejemplo, si el correo ya existe
      print('Error en el registro: ${e.message}');
      return false;
    }
  }

  Future<bool> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    try {
      final credenciales = await _firebaseAuth.signInWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      if (credenciales.user != null) {
        // Recuperar datos adicionales de Firestore
        final doc = await _firestore
            .collection('administradores')
            .doc(credenciales.user!.uid)
            .get();
        if (doc.exists) {
          _administradorActual = Administrador.desdeJson(doc.data()!);
          return true;
        }
      }
      return false;
    } on FirebaseAuthException catch (e) {
      print('Error en el inicio de sesión: ${e.message}');
      return false;
    }
  }

  Future<void> cerrarSesion() async {
    await _firebaseAuth.signOut();
    _administradorActual = null;
  }

  bool get estaAutenticado => _firebaseAuth.currentUser != null && _administradorActual != null;
}