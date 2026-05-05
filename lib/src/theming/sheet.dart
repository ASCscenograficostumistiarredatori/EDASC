import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/theme.dart';
import 'package:flutter/material.dart';

class CBottomSheet extends StatelessWidget {
  const CBottomSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      backgroundColor: bgPrimary,
      elevation: 0,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(Grid.x),
          child: child,
        );
      },
    );
  }
}
