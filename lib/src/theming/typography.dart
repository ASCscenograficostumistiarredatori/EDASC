import 'package:flutter/material.dart';

class TDisplay extends StatelessWidget {
  const TDisplay(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.fontWeight,
    this.height,
    this.fontSize,
  });

  final String label;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;
  final FontWeight? fontWeight;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Text(
      label,
      style: theme.textTheme.displayMedium!,
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
      fontWeight: fontWeight,
      height: height,
      fontSize: fontSize,
    );
  }
}

class THeadline extends StatelessWidget {
  const THeadline(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.fontWeight,
  });

  final String label;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Text(
      label,
      style: theme.textTheme.headlineMedium!,
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
      fontWeight: fontWeight,
    );
  }
}

class TTitle extends StatelessWidget {
  const TTitle(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.fontWeight,
  });

  final String label;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Text(
      label,
      style: theme.textTheme.titleMedium!,
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
      fontWeight: fontWeight,
    );
  }
}

class TBodyLarge extends StatelessWidget {
  const TBodyLarge(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.decoration,
    this.fontWeight,
    this.fontSize,
  });

  final String label;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Text(
      label,
      style: theme.textTheme.bodyMedium!.copyWith(
        fontSize: fontSize ?? 16,
        fontWeight: fontWeight,
      ),
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class TBody extends StatelessWidget {
  const TBody(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.decoration,
    this.fontStyle,
    this.fontWeight,
  });

  final String label;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Text(
      label,
      style: theme.textTheme.bodyMedium!.copyWith(
        decoration: decoration,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
      ),
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class TLabel extends StatelessWidget {
  const TLabel(
    this.label, {
    super.key,
    this.color,
    this.maxLines,
    this.textAlign = TextAlign.left,
    this.decoration,
  });

  final String label;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Text(
      label,
      style: theme.textTheme.labelMedium!
          .copyWith(decoration: decoration, overflow: TextOverflow.ellipsis),
      color: color,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class _Text extends StatelessWidget {
  const _Text(
    this.label, {
    super.key,
    required this.style,
    required this.color,
    required this.maxLines,
    required this.textAlign,
    this.fontWeight,
    this.height,
    this.fontSize,
  });

  final String label;
  final TextStyle style;
  final Color? color;
  final int? maxLines;
  final TextAlign textAlign;
  final FontWeight? fontWeight;
  final double? height;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: style.copyWith(
        color: color,
        fontWeight: fontWeight,
        height: height,
        fontSize: fontSize,
      ),
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}
