import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_autenticacion.dart';
import '../proveedores/proveedor_concursos.dart';
import '../proveedores/proveedor_proyectos.dart';
import 'pantalla_inicio_sesion.dart';
import 'pantalla_crear_concurso.dart';
import 'pantalla_lista_concursos.dart';

class PantallaPrincipal extends StatelessWidget {
  const PantallaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    // Accedemos a los proveedores para obtener datos ficticios
    final proveedorProyectos = Provider.of<ProveedorProyectos>(context, listen: false);
    final proveedorConcursos = Provider.of<ProveedorConcursos>(context, listen: false);
    
    // Simulamos algunas estadísticas
    final totalProyectos = proveedorProyectos.proyectos.length;
    final totalConcursos = proveedorConcursos.concursos.length;
    // Para el bosquejo, inventamos estos datos
    const proyectosAptos = 45;
    const proyectosPendientes = 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 1. Llama al método para cerrar sesión
              Provider.of<ProveedorAutenticacion>(context, listen: false).cerrarSesion();
              
              // 2. Forzamos la navegación a la pantalla de inicio
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const PantallaInicioSesion()),
                (Route<dynamic> route) => false, // Esto elimina todas las rutas anteriores
              );
            },
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Resumen General',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _StatCard(
                icon: Icons.folder_copy,
                label: 'Proyectos Totales',
                value: totalProyectos.toString(),
                color: Colors.blue,
              ),
              _StatCard(
                icon: Icons.emoji_events,
                label: 'Concursos Activos',
                value: totalConcursos.toString(),
                color: Colors.orange,
              ),
              _StatCard(
                icon: Icons.check_circle,
                label: 'Proyectos Aptos',
                value: proyectosAptos.toString(),
                color: Colors.green,
              ),
              _StatCard(
                icon: Icons.hourglass_top,
                label: 'Proyectos Pendientes',
                value: proyectosPendientes.toString(),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _ManagementCard(
            icon: Icons.list_alt,
            title: 'Gestionar Concursos',
            subtitle: 'Crear, editar y configurar ediciones del concurso',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PantallaListaConcursos()),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Widget interno para las tarjetas de estadísticas
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget interno para la tarjeta de gestión
class _ManagementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}