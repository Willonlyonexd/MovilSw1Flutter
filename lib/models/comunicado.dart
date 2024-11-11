class Comunicado {
  final String nombre;
  final String descripcion;
  final String fecha;
  final bool visto;
  final List<Multimedia> multimedia;

  Comunicado({
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    required this.visto,
    required this.multimedia,
  });

  factory Comunicado.fromJson(Map<String, dynamic> json) {
    var list = json['multimedia'] as List;
    List<Multimedia> multimediaList = list.map((i) => Multimedia.fromJson(i)).toList();

    return Comunicado(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      visto: json['visto'],
      multimedia: multimediaList,
    );
  }
}

class Multimedia {
  final String name;
  final String type;
  final String url;

  Multimedia({
    required this.name,
    required this.type,
    required this.url,
  });

  factory Multimedia.fromJson(Map<String, dynamic> json) {
    return Multimedia(
      name: json['name'],
      type: json['type'],
      url: json['url'],
    );
  }
}
