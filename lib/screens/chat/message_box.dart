import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class MessageBox extends StatelessWidget {
  final bool sender;
  final String message;
  const MessageBox({super.key, required this.sender, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: sender ? AppColors.primaryColor : AppColors.middleGray,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Text(
        message,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: sender ? AppColors.backgroundColor : AppColors.textPrimary,
        ),
      ),
    );
  }
}
