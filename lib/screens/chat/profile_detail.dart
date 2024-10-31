import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/chat/chat_tab.dart';

class ProfileDetail extends StatelessWidget {
  final String imageUrl;
  final String nickName;
  final String? bio;
  final String lastSeen;

  const ProfileDetail({
    super.key,
    required this.imageUrl,
    required this.nickName,
    required this.bio,
    required this.lastSeen,
  });

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
            Navigator.pop(context);
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 120,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      nickName,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  bio != null && bio != ''
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              bio!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: AppColors.middleBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lastSeen,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          lastSeen,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                          ),
                        ),
                  const SizedBox(height: 10),
                  const ChatTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
