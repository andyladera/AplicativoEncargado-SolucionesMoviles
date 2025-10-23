// lib/pantallas/pantalla_verificacion.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PantallaVerificacion extends StatelessWidget {
  const PantallaVerificacion({super.key});

  Future<void> _verificarConexion(BuildContext context) async {
    // Usamos el ScaffoldMessenger del context que nos llega
    final messenger = ScaffoldMessenger.of(context);
    
    messenger.showSnackBar(
      const SnackBar(content: Text('Iniciando verificación...')),
    );

    try {
      // 1. Verificar inicialización de Firebase
      if (Firebase.apps.isEmpty) {
        // Si usas flutterfire_cli, esto debería usar las opciones por defecto
        await Firebase.initializeApp();
      }
      messenger.showSnackBar(
        const SnackBar(content: Text('✅ Firebase Core inicializado.')),
      );

      // 2. Verificar inicio de sesión con Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('El usuario canceló el inicio de sesión.');
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      messenger.showSnackBar(
        SnackBar(content: Text('✅ Autenticación con Google exitosa: ${userCredential.user?.displayName}')),
      );

      // 3. Verificar escritura en Firestore
      await FirebaseFirestore.instance.collection('verificacion').doc('test').set({
        'mensaje': '¡Conexión exitosa!',
        'timestamp': FieldValue.serverTimestamp(),
        'usuario': userCredential.user?.email,
      });
      messenger.showSnackBar(
        const SnackBar(content: Text('✅ Escritura en Firestore exitosa.')),
      );

      // Si todo fue bien
      messenger.showSnackBar(
        const SnackBar(
          content: Text('¡VERIFICACIÓN COMPLETA Y EXITOSA! 🎉'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 10),
        ),
      );

    } catch (e) {
      // Si algo falla
      messenger.showSnackBar(
        SnackBar(
          content: Text('❌ ERROR EN LA VERIFICACIÓN: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 10),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificación de Firebase'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _verificarConexion(context),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text(
            'Iniciar Prueba de Conexión',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
