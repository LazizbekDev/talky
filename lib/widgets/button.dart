import 'package:flutter/material.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/utilities/status.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.onPressed,
    required this.text,
    this.imagePath,
    this.color = Colors.white,
    this.padding = 18.0,
    this.borderRadius = 8.0,
    this.fontSize = 16,
    this.status = Status.enabled,
  });
  final VoidCallback onPressed;
  final String text;
  final String? imagePath;
  final Color color;
  final double padding;
  final double borderRadius;
  final double fontSize;
  final Status status;

  @override
  Widget build(BuildContext context) {
    final paths = imagePath;
    return MaterialButton(
      onPressed: status == Status.enabled ? onPressed : null,
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
          if (status == Status.loading) ...[
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                color: Colors.black,
              ),
            ),
          ] else ...[
            if (paths != null) ...[
              Image.asset(
                paths,
                height: 24,
              ),
              const SizedBox(width: 25),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                color: status == Status.disabled
                    ? AppColors.lightGray
                    : color == AppColors.primaryColor
                        ? AppColors.backgroundColor
                        : AppColors.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
