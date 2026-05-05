class Magazine {
  final String id;
  final String imageUrl;
  final String title;
  final DateTime date;
  final String? pdfUrl;

  Magazine({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.date,
    required this.pdfUrl,
  });

  static Magazine fromJson(Map<String, dynamic> json) {
    return Magazine(
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      pdfUrl: json['pdf_url'],
    );
  }

  static List<Magazine> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Magazine.fromJson(json)).toList();
  }
}
