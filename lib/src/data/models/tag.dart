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
    final id = json['id'] as String;
    final name = json['name'] as String;
    late String color;
    try {
      color = json['color'] as String;
    } catch (e) {
      color = '#000000';
    }
    late String? textColor;
    try {
      textColor = json['text_color'] as String?;
    } catch (e) {
      textColor = null;
    }
    return Tag(
      id: id,
      name: name,
      color: HexColor.fromHex(color.replaceAll('#', '').substring(0, 6)),
      textColor: textColor != null
          ? HexColor.fromHex(textColor.replaceAll('#', '').substring(0, 6))
          : null,
    );
  }

  static List<Tag> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Tag.fromJson(json)).toList();
  }
}
