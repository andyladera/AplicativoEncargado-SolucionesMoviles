import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../proveedores/proveedor_concursos.dart';
import '../proveedores/proveedor_autenticacion.dart';
import 'pantalla_crear_concurso.dart';
import 'pantalla_editar_concurso.dart';
import 'pantalla_proyectos_concurso.dart';
import '../modelos/concurso.dart';

class PantallaListaConcursos extends StatelessWidget {
  const PantallaListaConcursos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Concursos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<ProveedorAutenticacion>().cerrarSesion();
            },
          ),
        ],
      ),
      body: Consumer<ProveedorConcursos>(
        builder: (context, proveedor, child) {
          if (proveedor.estado == EstadoCarga.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (proveedor.estado == EstadoCarga.error) {
            return const Center(child: Text('Error al cargar los concursos'));
          }

          if (proveedor.concursos.isEmpty) {
            return const Center(
              child: Text(
                'No has creado ningún concurso todavía.\n¡Anímate a crear el primero!',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: proveedor.concursos.length,
            itemBuilder: (context, index) {
              final concurso = proveedor.concursos[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(concurso.nombre),
                  subtitle: Text('Creado: ${concurso.fechaCreacion.toLocal().toString().split(' ')[0]}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PantallaEditarConcurso(concurso: concurso),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _mostrarDialogoConfirmacion(context, proveedor, concurso.id),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PantallaProyectosConcurso(concurso: concurso),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PantallaCrearConcurso()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Crear Concurso',
      ),
    );
  }

  void _mostrarDialogoConfirmacion(BuildContext context, ProveedorConcursos proveedor, String concursoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Estás seguro de que quieres eliminar este concurso?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
              onPressed: () {
                proveedor.eliminarConcurso(concursoId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}