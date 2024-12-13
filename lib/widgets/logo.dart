import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.dark = false});
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final inter = GoogleFonts.inter(fontSize: 80);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Talky",
          style: inter.copyWith(
              color: dark ? AppColors.textPrimary : AppColors.backgroundColor,
          ),
        ),
        Text(
          ".",
          style: inter.copyWith(
              color: dark ? AppColors.primaryColor : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
