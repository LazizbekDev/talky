import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class ProfileBar extends StatelessWidget implements PreferredSizeWidget {
  final String? profileImageUrl;
  final String partnerName;
  final String onlineStatus;
  final VoidCallback onPress;
  const ProfileBar({
    super.key,
    required this.profileImageUrl,
    required this.partnerName,
    required this.onlineStatus,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryColor,
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  "assets/images/pop.png",
                  width: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Back',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
            )
          ],
        ),
      ),
      centerTitle: true,
      title: GestureDetector(
        onTap: onPress,
        child: ListTile(
          title: Text(
            partnerName,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            onlineStatus,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
            ),
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: onPress,
          child: CircleAvatar(
            radius: 22,
            backgroundImage:
                profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
            child: profileImageUrl == null ? const Icon(Icons.person) : null,
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
