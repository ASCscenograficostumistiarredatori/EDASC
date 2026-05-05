import 'dart:ui';

import 'package:asc/src/core/extensions.dart';

class Profession {
  final String id;
  final String name;
  final Color color;

  Profession({
    required this.id,
    required this.name,
    required this.color,
  });

  static Profession fromJson(Map<String, dynamic> json) {
    return Profession(
      id: json['id'],
      name: json['name'],
      color: HexColor.fromHex((json['color'] as String).replaceAll('#', '')),
    );
  }

  static List<Profession> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Profession.fromJson(json)).toList();
  }
}
