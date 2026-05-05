class CinematicWork {
  final String id;
  final String? title;
  final String? year;
  final String? description;

  CinematicWork({
    required this.id,
    required this.title,
    required this.year,
    required this.description,
  });

  static CinematicWork fromJson(Map<String, dynamic> json) {
    return CinematicWork(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      description: json['description'],
    );
  }

  static List<CinematicWork> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CinematicWork.fromJson(json)).toList();
  }
}
