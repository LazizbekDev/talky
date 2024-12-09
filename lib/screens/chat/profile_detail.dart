import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:talky/models/user_model.dart';
import 'package:talky/providers/users_provider.dart';
import 'package:talky/providers/auth_provider.dart' as sign_out;
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/chat/chat_tab.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({super.key, required this.userId, required this.images});
  final String userId;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return FutureBuilder<UserModel?>(
      future: userProvider.fetchUserDetail(userId: userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Error: ${snapshot.error} $userId')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Profile Not Found')),
            body: const Center(child: Text('User profile not found')),
          );
        }

        final user = snapshot.data!;
        return _buildProfile(user, context);
      },
    );
  }

  Widget _buildProfile(UserModel user, BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    Future<void> onLogOut(BuildContext context) async {
      await userProvider.updateLastSeenStatus(false);
      if (!context.mounted) return;
      await Provider.of<sign_out.AuthProvider>(context, listen: false)
          .signOut();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.splash);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: AppColors.secondaryColor,
          icon: Image.asset(
            "assets/images/pop.png",
            width: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Back',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
        actions: [
          userId == FirebaseAuth.instance.currentUser?.uid
              ? PopupMenuButton<String>(
                  onSelected: (String value) {
                    debugPrint(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Option 1',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Edit profile'),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'logout',
                        onTap: () => Navigator.pushReplacementNamed(
                            context, RouteNames.splash),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Log out'),
                            Icon(Icons.logout),
                          ],
                        ),
                      ),
                    ];
                  },
                )
              : const SizedBox.shrink(),
        ],
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
                    backgroundColor: const Color(0xFFF0F0F0),
                    backgroundImage: CachedNetworkImageProvider(user.imageUrl),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Text(
                      user.nick,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (user.description.isNotEmpty)
                    Text(
                      user.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.middleBlack,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    user.isOnline
                        ? 'Online'
                        : 'Last seen: ${_formatLastSeen(user.lastSeen)}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 10),
                  ),
                  userId != FirebaseAuth.instance.currentUser?.uid
                      ? ChatTab(
                          images: images,
                        )
                      : const SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    if (difference.inMinutes < 1) return 'just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} mins ago';
    if (difference.inHours < 24) return '${difference.inHours} hrs ago';
    return '${difference.inDays} days ago';
  }
}
