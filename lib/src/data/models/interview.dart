class Interview {
  final String id;
  final String? url;
  final String? title;
  final String? description;

  Interview({
    required this.id,
    required this.url,
    this.title,
    this.description,
  });

  /// True quando la riga ha davvero un file audio collegato.
  /// In DB capita di trovare stringhe vuote o piene di spazi: le trattiamo
  /// come "nessun audio" per non mostrare un player che non può suonare.
  bool get hasAudio => url != null && url!.trim().isNotEmpty;

  static Interview fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'].toString(),
      url: json['url'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
    );
  }

  static List<Interview> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Interview.fromJson(json)).toList();
  }
}
