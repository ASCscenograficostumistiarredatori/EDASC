class Bibliography {
  final String id;
  final String? title;
  final String? description;

  Bibliography({
    required this.id,
    required this.title,
    required this.description,
  });

  static Bibliography fromJson(Map<String, dynamic> json) {
    return Bibliography(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  static List<Bibliography> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Bibliography.fromJson(json)).toList();
  }
}
