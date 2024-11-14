class MultimediaItem {
  final String name;
  final String type;
  final String url;
  String? translatedTranscription; // Campo para guardar la transcripción traducida

  MultimediaItem({
    required this.name,
    required this.type,
    required this.url,
    this.translatedTranscription, // Campo opcional
  });

  factory MultimediaItem.fromJson(Map<String, dynamic> json) {
    return MultimediaItem(
      name: json['name'],
      type: json['type'],
      url: json['url'],
      translatedTranscription: null, // Inicialmente vacío
    );
  }
}

class Comunicado {
  String nombre;            // Eliminado `final` para permitir cambios
  String descripcion;       // Eliminado `final` para permitir cambios
  final String fecha;
  bool visto;               // Puede cambiar, así que debe ser no `final`
  final List<MultimediaItem> multimedia;

  Comunicado({
    required this.nombre,
    required this.descripcion,
    required this.fecha,
    this.visto = false, // Inicializado como `false` por defecto
    required this.multimedia,
  });

  factory Comunicado.fromJson(Map<String, dynamic> json) {
    var multimediaJson = json['multimedia'] as List;
    List<MultimediaItem> multimediaItems = multimediaJson.map((item) => MultimediaItem.fromJson(item)).toList();

    return Comunicado(
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      visto: json['visto'] ?? false, // Si `visto` no existe en el JSON, se establece como `false`
      multimedia: multimediaItems,
    );
  }
}
