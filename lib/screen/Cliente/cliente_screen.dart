import 'package:flutter/material.dart';
import 'package:recarga_telefonica_flutter/screen/Cliente/cliente_register_screen.dart';
import 'package:recarga_telefonica_flutter/widget/components/floating_button.dart';
import 'package:recarga_telefonica_flutter/widget/components/text_icon_form.dart';
import '../../widget/Cliente/app_bar_cliente.dart';
import '../../widget/Cliente/list_cliente_widget.dart';
import '../../model/cliente.dart';
import '../../data/cliente_dao.dart';

class ClienteScreen extends StatefulWidget {
  const ClienteScreen({super.key});

  @override
  State<ClienteScreen> createState() => _ClienteScreenState();
}

class _ClienteScreenState extends State<ClienteScreen> {
  // Future<List<Cliente>>? _clientesFuture;
  List<Cliente> _clientes = [];
  bool _isLoadingMore = false;
  final TextEditingController _searchController = TextEditingController();
  int _offset = 0;
  final int _limit = 9;

  @override
  void initState() {
    super.initState();
    _loadClientes();
    _searchController.addListener(_searchClientes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadClientes({String query = '', bool isLoadMore = false}) async {
    if (_isLoadingMore && isLoadMore) return;

    setState(() {
      if (!isLoadMore) {
        _offset = 0;
        _clientes = [];
      }
      _isLoadingMore = true;
    });

    try {
      final newClientes = await ClienteDao()
          .searchClientes(query, limit: _limit, offset: _offset);

      setState(() {
        _isLoadingMore = false;
        if (newClientes.isEmpty) {
          _offset -= _limit; 
        } else {
          _clientes.addAll(newClientes);
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _searchClientes() {
    final query = _searchController.text;
    _loadClientes(query: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCliente(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextIconForm(
              text: 'Buscar Cliente',
              icon: Icons.search,
              keyword: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              controller: _searchController,
            ),
            const Divider(
              height: 35,
              thickness: 1.6,
            ),
            Expanded(
              child: ListClienteWidget(
                clientes: _clientes,
                onUpdate: _loadClientes,
                isLoadingMore: _isLoadingMore,
                onLoadMore: () {
                  if (!_isLoadingMore) {
                    setState(() {
                      _offset += _limit;
                      _loadClientes(
                        query: _searchController.text,
                        isLoadMore: true,
                      );
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingButton(
        text: 'Agregar Cliente.',
        icon: Icons.person_add_alt_rounded,
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ClienteRegisterScreen(),
            ),
          );

          if (result == true) {
            setState(() {
              _loadClientes();
            });
          }
        },
      ),
    );
  }
}
