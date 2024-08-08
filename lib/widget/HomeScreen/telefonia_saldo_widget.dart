import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/telefonia.dart';

class TelefoniaSaldoWidget extends StatelessWidget {
  const TelefoniaSaldoWidget({
    super.key,
    required this.telefoniasFuture,
    required this.onUpdate,
  });

  final Future<List<Telefonia>> telefoniasFuture;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Telefonia>>(
      future: telefoniasFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Telefonia>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No se encontraron Telefonias registradas.',
              style: GoogleFonts.dosis(fontSize: 17),
            ),
          );
        } else {
          final telefonias = snapshot.data!;
          return SizedBox(
            height: 130,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: telefonias.map((telefonia) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    color: const Color.fromARGB(255, 223, 238, 245),
                    margin: const EdgeInsets.symmetric(horizontal: 3.5),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8), // Bordes redondeados
                    ),
                    child: SizedBox(
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              telefonia.nombre,
                              style: GoogleFonts.dosis(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Saldo: ${telefonia.saldo} bs.',
                              style: GoogleFonts.titilliumWeb(
                                fontSize: 15,
                                color: Colors.blueGrey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
