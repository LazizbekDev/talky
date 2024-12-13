import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class Suggest extends StatelessWidget {
  const Suggest({
    super.key,
    this.login = false,
    required this.onTap,
  });
  final bool login;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final inter = GoogleFonts.inter(fontSize: 14);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? "Don't you have an account" : "Already have an account?",
          style: inter.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            login ? "Sign up here" : "Sign in here",
            style: inter.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
