class Exhibition {
  final String id;
  final String? url;

  Exhibition({
    required this.id,
    required this.url,
  });

  static Exhibition fromJson(Map<String, dynamic> json) {
    return Exhibition(
      id: json['id'],
      url: json['url'],
    );
  }

  static List<Exhibition> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Exhibition.fromJson(json)).toList();
  }
}
