import 'package:flutter/material.dart';

class SplashConnector extends StatelessWidget {
  const SplashConnector({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: const Color(0xFFf1f1f1),
          body: Center(
            child: Image.asset(
              'assets/icona_asc.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
      ),
    );
  }
}
