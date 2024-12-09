import 'package:flutter/material.dart';
import 'package:talky/utilities/app_colors.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.controller,
    this.obscureText = true,
    this.hintText = '',
    this.suffixIcon,
    this.labelText,
  });
  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final IconButton? suffixIcon;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: AppColors.lightGray,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        suffixIcon: suffixIcon,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}
