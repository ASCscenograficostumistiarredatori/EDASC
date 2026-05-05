class CustomFolders {
  final String name;
  final String content;

  CustomFolders({
    required this.name,
    required this.content,
  });

  static CustomFolders fromJson(Map<String, dynamic> json) {
    return CustomFolders(
      name: json['name'],
      content: json['content'],
    );
  }

  static List<CustomFolders> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CustomFolders.fromJson(json)).toList();
  }
}
