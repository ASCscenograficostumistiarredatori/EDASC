class Interview {
  final String id;
  final String? url;

  Interview({
    required this.id,
    required this.url,
  });

  static Interview fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'],
      url: json['url'],
    );
  }

  static List<Interview> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Interview.fromJson(json)).toList();
  }
}
