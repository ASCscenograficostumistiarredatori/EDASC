import 'package:asc/src/theming/typography.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.color,
    this.textColor,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final Color? textColor;
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Chip(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        side: BorderSide(color: color, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        label: TBody(
          label,
          color: textColor ?? color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
