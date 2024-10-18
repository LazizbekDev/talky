import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:talky/utilities/app_colors.dart';

class MessageBox extends StatelessWidget {
  final bool sender;
  final String message;
  final Timestamp timestamp;

  const MessageBox({
    super.key,
    required this.sender,
    required this.message,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    DateTime date = timestamp.toDate();
    String formattedTime = DateFormat('HH:mm').format(date);

    return Column(
      crossAxisAlignment:
          sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
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
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            formattedTime, // Display the formatted time here
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
