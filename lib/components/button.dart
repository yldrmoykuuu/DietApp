import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final double? borderRadius;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradientColors;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.borderRadius = 12,
    this.elevation = 2,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? [Colors.lightGreenAccent, Colors.greenAccent];

    return Material(
      elevation: elevation!,
      borderRadius: BorderRadius.circular(borderRadius!),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(borderRadius!),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius!),
          onTap: onPressed,
          child: Container(
            padding: padding,
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
