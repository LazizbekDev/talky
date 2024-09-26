import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        await FirebaseAuth.instance
            .authStateChanges()
            .firstWhere((user) => user != null);
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        return userDoc.data();
      } else {
        debugPrint('User not found');
        return null;
      }
    } catch (e) {
      debugPrint('Failed to fetch user profile: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchProfile() async {
    return await fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 30,
            right: 30,
            bottom: 40,
          ),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _fetchProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error loading profile'));
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('No profile found'));
              }

              final userData = snapshot.data!;
              final profileImageUrl = userData['image_url'];

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 27,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  Text(
                    'Chats',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/search.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {},
          shape: const CircleBorder(),
          child: Image.asset(
            'assets/images/FloatingMenu.png',
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }
}
