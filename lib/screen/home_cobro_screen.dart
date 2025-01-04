import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/data/cliente_dao.dart';
import '../widget/HomeScreen/app_bar_cobro.dart';
import '../widget/HomeScreen/menu_drawer_widget.dart';

class HomeCobroScreen extends StatefulWidget {
  const HomeCobroScreen({super.key});

  @override
  State<HomeCobroScreen> createState() => _HomeCobroScreenState();
}

class _HomeCobroScreenState extends State<HomeCobroScreen> {
  final clienteDao = ClienteDao();
  String _selectedFilter = 'cliente';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCobro(),
      drawer: const MenuDrawerWidget(),
      body: Column(
        children: [
          _buildDeudaTotal(clienteDao), // Mostrar deuda total
          const Divider(endIndent: 30, indent: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _filterButton('Cliente', Icons.person_2_rounded, 'cliente'),
              _filterButton('Fecha', Icons.date_range, 'fecha'),
            ],
          ),
          const Divider(endIndent: 30, indent: 30),
          Expanded(
            child: _selectedFilter == 'cliente'
                ? _buildClientesConDeudas(clienteDao)
                : _buildRecargasPorFecha(clienteDao),
          ),
        ],
      ),
    );
  }

  Widget _buildDeudaTotal(ClienteDao clienteDao) {
    return Card(
      margin: const EdgeInsets.all(20.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<double>(
          future: clienteDao
              .calcularDeudaTotal(), // Llama al método que suma las deudas
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Indicador de carga
            } else if (snapshot.hasError) {
              return const Text('Error al cargar la deuda total');
            } else {
              return Text(
                'Deuda Total: ${snapshot.data?.toStringAsFixed(2) ?? "0.00 bs."} bs.',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _filterButton(String text, IconData icon, String filterValue) {
    final isSelected = _selectedFilter == filterValue;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : Colors.black,
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
      onPressed: () => setState(() => _selectedFilter = filterValue),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildClientesConDeudas(ClienteDao clienteDao) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: clienteDao.obtenerRecargasPorCliente(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar las deudas'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final groupedData = _groupDataByCliente(snapshot.data!);

          return ListView.builder(
            itemCount: groupedData.length,
            itemBuilder: (context, index) {
              final clienteNombre = groupedData.keys.elementAt(index);
              final clienteData = groupedData[clienteNombre]!;

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: ExpansionTile(
                  title: Text(clienteNombre),
                  subtitle: Text(
                      'Deuda: ${clienteData['deuda_total'].toStringAsFixed(2)} bs'),
                  children: clienteData['recargas'].map<Widget>((recarga) {
                    final telefonia =
                        recarga['telefonia_nombre'] ?? 'Desconocido';

                    return ListTile(
                      title: Text(
                          'Tel: ${recarga['telefono_numero']} - $telefonia'),
                      subtitle: Text(
                          'Monto: ${recarga['recarga_monto'].toStringAsFixed(2)} bs.'),
                      trailing: Text('Estado: ${recarga['recarga_estado']}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No hay deudas pendientes.'));
        }
      },
    );
  }

  Widget _buildRecargasPorFecha(ClienteDao clienteDao) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: clienteDao.obtenerRecargasPorFecha(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar las recargas'));
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index];
              final fecha = data['fecha'] ?? 'Fecha no disponible';
              final montoTotal = data['monto_total'] ?? 0.0;
              final recargas = data['detalles'] ?? [];

              return Card(
                margin: const EdgeInsets.all(10.0),
                child: ExpansionTile(
                  title: Text(fecha),
                  subtitle: Text('Total: bs. ${montoTotal.toStringAsFixed(2)}'),
                  children: recargas.map<Widget>((recarga) {
                    final telefonia =
                        recarga['telefonia_nombre'] ?? 'Desconocido';
                    final numeroTelefono =
                        recarga['numero_telefono'] ?? 'Desconocido';
                    final monto = recarga['monto'] ?? 0.0;
                    final estado = recarga['estado'] ?? 'Desconocido';
                    return ListTile(
                      title: Text('Tel: $numeroTelefono - $telefonia'),
                      subtitle: Text('Monto: bs. ${monto.toStringAsFixed(2)}'),
                      trailing: Text('Estado: $estado'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No hay recargas registradas.'));
        }
      },
    );
  }

  Map<String, Map<String, dynamic>> _groupDataByCliente(
      List<Map<String, dynamic>> data) {
    final Map<String, Map<String, dynamic>> groupedData = {};

    for (var recarga in data) {
      final clienteNombre = recarga['cliente_nombre'] as String;
      final deudaTotal = recarga['deuda_total'] as double;

      if (!groupedData.containsKey(clienteNombre)) {
        groupedData[clienteNombre] = {
          'deuda_total': deudaTotal,
          'recargas': [],
        };
      }
      groupedData[clienteNombre]!['recargas'].add(recarga);
    }

    return groupedData;
  }
}
