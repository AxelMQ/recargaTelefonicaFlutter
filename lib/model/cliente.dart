class Cliente {
  int? id;
  String nombre;

  Cliente({
    this.id,
    required this.nombre,
  });

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'nombre' : nombre,
    };
  }

  factory Cliente.fromMap(Map<String, dynamic> map){
    return Cliente(
      id: map['id'],
      nombre: map['nombre'],
    );
  }

}