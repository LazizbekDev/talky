// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/user_image_picker.dart';

class SetProfile extends StatelessWidget {
  const SetProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: AppColors.secondaryColor,
          icon: Image.asset(
            "assets/images/pop.png",
            width: 20,
          ),
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.home);
          },
        ),
        title: Text(
          'Back',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          left: 28,
          top: 26,
          right: 28,
          bottom: 100,
        ),
        child: const Center(
          child: UserImagePicker(),
        ),
      ),
    );
  }
}
