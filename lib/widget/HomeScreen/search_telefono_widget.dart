import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recarga_telefonica_flutter/data/telefono_dao.dart';
import 'package:recarga_telefonica_flutter/screen/Recarga/recarga_screen.dart';
import '../../model/telefono.dart';
import '../components/text_icon_form.dart';

class SearchTelefonoWidget extends StatefulWidget {
  const SearchTelefonoWidget({
    super.key,
  });

  @override
  State<SearchTelefonoWidget> createState() => _SearchTelefonoWidgetState();
}

class _SearchTelefonoWidgetState extends State<SearchTelefonoWidget> {
  final TextEditingController _phoneController = TextEditingController();
  List<Telefono> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_searchTelefonos);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _searchTelefonos() async {
    final query = _phoneController.text;
    if (query.isNotEmpty) {
      final dao = TelefonoDao();
      final results = await dao.searchTelefonos(query);
      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextIconForm(
          text: 'Ingrese Numero',
          icon: Icons.phone_android_rounded,
          controller: _phoneController,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final telefono = _searchResults[index];
              final clienteNombre = telefono.cliente?.nombre ?? 'Desconocido';
              final telefoniaNombre =
                  telefono.telefonia?.nombre ?? 'Sin telefonia';

              // Construye el subtitle sin comas innecesarias
              final subtitle = [clienteNombre, telefoniaNombre]
                  .where((item) => item.isNotEmpty) // Filtra elementos vacíos
                  .join(' - '); // Une los elementos con guion

              return ListTile(
                title: Text(
                  telefono.numero.toString(),
                  style: GoogleFonts.titilliumWeb(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                subtitle: Text(
                  subtitle,
                  style: GoogleFonts.dosis(
                    fontWeight: FontWeight.w300,
                    fontSize: 17,
                  ),
                ),
                onTap: () {
                  // print(telefono.cliente!.nombre);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecargaScreen(
                        telefono: telefono,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
