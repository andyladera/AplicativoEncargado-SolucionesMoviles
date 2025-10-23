import 'package:flutter/material.dart';
import 'package:proyectos_admin/pantallas/pantalla_verificacion.dart'; 

void main() {
  runApp(const MyAppVerificacion());
}

class MyAppVerificacion extends StatelessWidget {
  const MyAppVerificacion({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Test de Verificación',
      home: PantallaVerificacion(),
      debugShowCheckedModeBanner: false,
    );
  }
}
