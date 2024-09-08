import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String? imagePath;
  final Color color;
  final double padding;
  final double borderRadius;
  final double fontSize;

  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.imagePath,
    this.color = Colors.white,
    this.padding = 18.0,
    this.borderRadius = 8.0,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      minWidth: double.infinity,
      padding: EdgeInsets.symmetric(vertical: padding),
      child: Row(
        mainAxisAlignment: imagePath != null
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null) ...[
            Image.asset(
              imagePath!,
              height: 24,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
