import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class Suggest extends StatelessWidget {
  final bool login;
  const Suggest({super.key, this.login = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't you have an account" : "Already have an account?",
          style: GoogleFonts.inter(
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            login ? "Sign up here" : "Sign in here",
            style: GoogleFonts.inter(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
