import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/localization/localization.dart';

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
    final locale = context.locale;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          login ? locale.signUpSuggest : locale.signInSuggest,
          style: inter.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            login ? locale.showSignUp : locale.showSignIn,
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
