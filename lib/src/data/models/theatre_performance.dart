class TheatrePerformance {
  final String id;
  final String title;

  TheatrePerformance({
    required this.id,
    required this.title,
  });

  static TheatrePerformance fromJson(Map<String, dynamic> json) {
    return TheatrePerformance(
      id: json['id'],
      title: json['title'],
    );
  }

  static List<TheatrePerformance> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TheatrePerformance.fromJson(json)).toList();
  }
}
