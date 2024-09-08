import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class Logo extends StatelessWidget {
  final bool dark;
  const Logo({super.key, this.dark = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Talky",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 80,
              color: dark ? AppColors.textPrimary : AppColors.backgroundColor,
            ),
          ),
        ),
        Text(
          ".",
          style: GoogleFonts.inter(
            textStyle: TextStyle(
              fontSize: 80,
              color:  dark ? AppColors.primaryColor : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
