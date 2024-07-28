class Telefonia {
  int? id;
  String nombre;
  double comision;
  String logo;
  double saldo;
  int telefono;

  Telefonia({
    this.id,
    required this.nombre,
    required this.comision,
    required this.logo,
    required this.saldo,
    required this.telefono,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre' : nombre,
      'comision' : comision,
      'logo' : logo,
      'saldo' : saldo,
      'telefono' : telefono,
    };
  }

  factory Telefonia.fromMap(Map<String, dynamic> map){
    return Telefonia(
      id: map['id'],
      nombre: map['nombre'],
      comision: map['comision'],
      logo: map['logo'],
      saldo: map['saldo'],
      telefono: map['telefono'],
    );
  }
  
}