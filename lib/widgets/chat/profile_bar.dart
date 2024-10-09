import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class ProfileBar extends StatelessWidget {
  final String? profileImageUrl;
  final String partnerName;
  const ProfileBar(
      {super.key, required this.profileImageUrl, required this.partnerName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryColor,
              ),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                "assets/images/pop.png",
                width: 20,
              ),
            ),
            Text(
              'Back',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        Text(
          partnerName,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        CircleAvatar(
          radius: 25,
          backgroundImage:
              profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
          child: profileImageUrl == null ? const Icon(Icons.person) : null,
        ),
      ],
    );
  }
}
