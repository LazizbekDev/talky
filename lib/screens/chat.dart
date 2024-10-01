import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:talky/providers/auth_provider.dart' as sign_out;
import 'package:talky/routes/route_names.dart';
import 'package:talky/screens/p2p_chat_screen.dart';
import 'package:talky/utilities/app_colors.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  Future<Map<String, dynamic>?> fetchUserProfile() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
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

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return [];

      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isNotEqualTo: currentUser.uid)
          .get();

      return usersSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Failed to fetch users: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 30,
            right: 30,
            bottom: 40,
          ),
          child: Column(
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: fetchUserProfile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return const Text('Error loading profile');
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('No profile found');
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
                        onPressed: () {
                          Provider.of<sign_out.AuthProvider>(context,
                                  listen: false)
                              .signOut();
                          Navigator.pushReplacementNamed(
                              context, RouteNames.splash);
                        },
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
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading users'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No users found'));
                    }

                    final users = snapshot.data!;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final profileImageUrl = user['image_url'];
                        final userName = user['nick'] ?? 'Unknown User';

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: profileImageUrl != null
                                ? NetworkImage(profileImageUrl)
                                : null,
                            child: profileImageUrl == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(userName),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => P2PChatScreen(
                                  chatPartnerId: user['uid'],
                                  chatPartnerName: userName,
                                  chatPartnerImage: profileImageUrl,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            Provider.of<sign_out.AuthProvider>(context, listen: false).signOut();
            // Navigator.pushNamed(context, RouteNames.splash);
          },
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
