import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../proveedores/proveedor_proyectos.dart';
import '../modelos/concurso.dart';
import '../modelos/proyecto.dart';
import 'pantalla_detalle_proyecto.dart';

class PantallaProyectosConcurso extends StatefulWidget {
  final Concurso concurso;

  const PantallaProyectosConcurso({super.key, required this.concurso});

  @override
  State<PantallaProyectosConcurso> createState() => _PantallaProyectosConcursoState();
}

class _PantallaProyectosConcursoState extends State<PantallaProyectosConcurso> {
  String? _categoriaSeleccionada;
  EstadoProyecto? _estadoSeleccionado;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProveedorProyectos>(context, listen: false)
          .cargarProyectosPorConcurso(widget.concurso.id);
    });
  }

  void _filtrarPorCategoria(String? categoria) {
    setState(() {
      _categoriaSeleccionada = categoria;
    });
  }

  void _filtrarPorEstado(EstadoProyecto? estado) {
    setState(() {
      _estadoSeleccionado = estado;
    });
  }

  List<Proyecto> _aplicarFiltros(List<Proyecto> proyectos) {
    var proyectosFiltrados = proyectos;

    if (_categoriaSeleccionada != null) {
      proyectosFiltrados = proyectosFiltrados
          .where((p) => p.categoriaId == _categoriaSeleccionada)
          .toList();
    }

    if (_estadoSeleccionado != null) {
      proyectosFiltrados = proyectosFiltrados
          .where((p) => p.estado == _estadoSeleccionado)
          .toList();
    }

    return proyectosFiltrados;
  }

  Color _obtenerColorEstado(EstadoProyecto estado) {
    switch (estado) {
      case EstadoProyecto.enviado:
        return Colors.blue;
      case EstadoProyecto.enRevision:
        return Colors.orange;
      case EstadoProyecto.aprobado:
        return Colors.green;
      case EstadoProyecto.rechazado:
        return Colors.red;
      case EstadoProyecto.ganador:
        return Colors.purple;
    }
  }

  String _obtenerTextoEstado(EstadoProyecto estado) {
    switch (estado) {
      case EstadoProyecto.enviado:
        return 'Enviados';
      case EstadoProyecto.enRevision:
        return 'En Revisión';
      case EstadoProyecto.aprobado:
        return 'Aprobados';
      case EstadoProyecto.rechazado:
        return 'Rechazados';
      case EstadoProyecto.ganador:
        return 'Ganadores';
    }
  }

  Widget _construirTarjetaProyecto(Proyecto proyecto) {
    final formatoFecha = DateFormat('dd/MM/yyyy HH:mm');
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: InkWell(
        onTap: () async {
          // Navega y espera un resultado para saber si debe refrescar
          final actualizado = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (context) => PantallaDetalleProyecto(
                proyecto: proyecto,
                concurso: widget.concurso,
              ),
            ),
          );
          // Si la pantalla de detalle devolvió 'true', recarga los proyectos
          if (actualizado == true && mounted) {
            Provider.of<ProveedorProyectos>(context, listen: false)
                .cargarProyectosPorConcurso(widget.concurso.id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      proyecto.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _obtenerColorEstado(proyecto.estado).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _obtenerColorEstado(proyecto.estado).withOpacity(0.3)),
                    ),
                    child: Text(
                      _obtenerTextoEstado(proyecto.estado).replaceAll('s', ''), // Quita la 's' para singular
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _obtenerColorEstado(proyecto.estado),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      proyecto.nombreEstudiante,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      proyecto.correoEstudiante,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    proyecto.categoriaId,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    formatoFecha.format(proyecto.fechaEnvio),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _construirEstadisticas(Map<EstadoProyecto, int> estadisticas) {
    final total = estadisticas.values.fold(0, (sum, count) => sum + count);
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bar_chart, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Estadísticas del Concurso',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Total: $total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: estadisticas.entries.map((entry) {
                final estado = entry.key;
                final count = entry.value;
                final color = _obtenerColorEstado(estado);
                
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_obtenerTextoEstado(estado)}: $count',
                        style: TextStyle(fontWeight: FontWeight.w500, color: color.withBlue(100)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proyectos - ${widget.concurso.nombre}'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          // --- INICIO DEL CÓDIGO AÑADIDO ---
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Exportar a Excel',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Simulación: Exportando datos a Excel...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          ),
          // --- FIN DEL CÓDIGO AÑADIDO ---
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'refresh') {
                Provider.of<ProveedorProyectos>(context, listen: false)
                    .cargarProyectosPorConcurso(widget.concurso.id);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Actualizar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<ProveedorProyectos>(
        builder: (context, proveedor, child) {
          if (proveedor.cargando && proveedor.proyectos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (proveedor.mensajeError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar proyectos',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    proveedor.mensajeError!,
                    style: TextStyle(color: Colors.grey[500]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => proveedor.cargarProyectosPorConcurso(widget.concurso.id),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final proyectosFiltrados = _aplicarFiltros(proveedor.proyectos);

          if (proveedor.proyectos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay proyectos enviados',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Los estudiantes aún no han enviado proyectos para este concurso',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _construirEstadisticas(proveedor.estadisticas),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _categoriaSeleccionada,
                        hint: const Text('Filtrar por categoría'),
                        onChanged: _filtrarPorCategoria,
                        items: widget.concurso.categorias
                            .map((c) => DropdownMenuItem(value: c.nombre, child: Text(c.nombre)))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<EstadoProyecto>(
                        value: _estadoSeleccionado,
                        hint: const Text('Filtrar por estado'),
                        onChanged: _filtrarPorEstado,
                        items: EstadoProyecto.values
                            .map((e) => DropdownMenuItem(value: e, child: Text(_obtenerTextoEstado(e))))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: proyectosFiltrados.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.filter_list_off, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No hay proyectos que coincidan con los filtros'),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => proveedor.cargarProyectosPorConcurso(widget.concurso.id),
                        child: ListView.builder(
                          itemCount: proyectosFiltrados.length,
                          itemBuilder: (context, index) {
                            return _construirTarjetaProyecto(proyectosFiltrados[index]);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}