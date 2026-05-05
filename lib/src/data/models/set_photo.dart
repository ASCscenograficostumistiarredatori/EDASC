class SetPhoto {
  final String id;
  final String url;

  SetPhoto({required this.id, required this.url});

  static SetPhoto fromJson(Map<String, dynamic> json) {
    return SetPhoto(
      id: json['id'],
      url: json['url'],
    );
  }

  static List<SetPhoto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SetPhoto.fromJson(json)).toList();
  }
}
