import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/screens/chat/p2p_chat_screen.dart';
import 'package:talky/utilities/app_colors.dart';

class UserList extends StatelessWidget {
  const UserList({
    super.key,
    required this.profileImageUrl,
    required this.userName,
    required this.chatPartnerId,
    required this.lastMessage,
    required this.lastSeenTime,
    required this.isOnline,
  });

  final dynamic profileImageUrl;
  final String userName;
  final String chatPartnerId;
  final String? lastMessage;
  final String lastSeenTime;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage:
                profileImageUrl != null ? NetworkImage(profileImageUrl) : null,
            child: profileImageUrl == null ? const Icon(Icons.person) : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            userName,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            lastSeenTime,
            style: GoogleFonts.inter(
              color: const Color(0xFF58616A),
              fontSize: 12,
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lastMessage ?? "No messages yet",
            style: GoogleFonts.inter(
              color: const Color(0xFF58616A),
              fontSize: 14,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => P2PChatScreen(
              chatPartnerId: chatPartnerId,
              chatPartnerName: userName,
              chatPartnerImage: profileImageUrl,
              onlineStatus: lastSeenTime,
            ),
          ),
        );
      },
    );
  }
}
