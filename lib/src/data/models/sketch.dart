class Sketch {
  final String id;
  final String url;

  Sketch({required this.id, required this.url});

  static Sketch fromJson(Map<String, dynamic> json) {
    return Sketch(
      id: json['id'],
      url: json['url'],
    );
  }

  static List<Sketch> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Sketch.fromJson(json)).toList();
  }
}
