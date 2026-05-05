class VideoInterview {
  final String id;
  final String url;

  VideoInterview({required this.id, required this.url});

  static VideoInterview fromJson(Map<String, dynamic> json) {
    return VideoInterview(
      id: json['id'],
      url: json['url'],
    );
  }

  static List<VideoInterview> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => VideoInterview.fromJson(json)).toList();
  }
}
