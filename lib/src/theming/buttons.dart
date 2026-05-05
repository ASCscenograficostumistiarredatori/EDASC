import 'package:asc/src/theming/grid.dart';
import 'package:asc/src/theming/theme.dart';
import 'package:asc/src/theming/typography.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brandColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Grid.m),
          ),
          padding:
              const EdgeInsets.symmetric(vertical: Grid.m, horizontal: Grid.m),
        ),
        child: TBodyLarge(
          label,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// #828282
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF828282),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Grid.m),
          ),
          padding:
              const EdgeInsets.symmetric(vertical: Grid.m, horizontal: Grid.m),
        ),
        child: TBody(
          label,
          color: Colors.white,
        ),
      ),
    );
  }
}
