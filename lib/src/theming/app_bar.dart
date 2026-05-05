import 'package:asc/src/presentation/camera/camera.dart';
import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:flutter/material.dart';

AppBar appBar(BuildContext context, {required String title}) {
  return AppBar(
    title: TBodyLarge(
      title,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CameraConnector(),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.only(right: Grid.m),
          child: Icon(
            Icons.qr_code_2,
            size: 24,
          ),
        ),
      ),
    ],
  );
}
