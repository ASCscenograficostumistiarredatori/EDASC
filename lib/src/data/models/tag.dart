import 'dart:ui';

import 'package:asc/src/core/extensions.dart';

class Tag {
  final String id;
  final String name;
  final Color color;
  final Color? textColor;

  Tag({
    required this.id,
    required this.name,
    required this.color,
    this.textColor,
  });

  static Tag fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      color: HexColor.fromHex((json['color'] as String).replaceAll('#', '')),
      textColor: json['text_color'] != null
          ? HexColor.fromHex((json['text_color'] as String).replaceAll('#', ''))
          : null,
    );
  }

  static List<Tag> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Tag.fromJson(json)).toList();
  }
}
