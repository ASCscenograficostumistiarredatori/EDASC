class ScenePhoto {
  final String id;
  final String url;

  ScenePhoto({
    required this.id,
    required this.url,
  });

  static ScenePhoto fromJson(Map<String, dynamic> json) {
    return ScenePhoto(
      id: json['id'],
      url: json['url'],
    );
  }

  static List<ScenePhoto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ScenePhoto.fromJson(json)).toList();
  }
}
