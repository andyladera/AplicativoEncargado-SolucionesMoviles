import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'proveedores/proveedor_autenticacion.dart';
import 'proveedores/proveedor_concursos.dart';
import 'proveedores/proveedor_proyectos.dart';
import 'pantallas/pantalla_inicio_sesion.dart';
import 'pantallas/pantalla_principal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AdminProyectosApp());
}

class AdminProyectosApp extends StatelessWidget {
  const AdminProyectosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProveedorAutenticacion()),
        ChangeNotifierProvider(create: (_) => ProveedorConcursos()),
        ChangeNotifierProvider(create: (_) => ProveedorProyectos()),
      ],
      child: MaterialApp(
        title: 'Admin Proyectos EPIS',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: Consumer<ProveedorAutenticacion>(
          builder: (context, proveedor, child) {
            return proveedor.estaAutenticado
                ? const PantallaPrincipal()
                : const PantallaInicioSesion();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
