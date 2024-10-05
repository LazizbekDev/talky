import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/providers/auth_provider.dart' as sign_out;
import 'package:provider/provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/chat/user_list.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  Future<Map<String, dynamic>> fetchUserProfileAndAllUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception("User not signed in");
      }

      final userProfileFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final allUsersFuture = FirebaseFirestore.instance
          .collection('users')
          .where('uid', isNotEqualTo: currentUser.uid)
          .get();

      final results = await Future.wait([userProfileFuture, allUsersFuture]);

      final userProfile = results[0] as DocumentSnapshot;
      final usersSnapshot = results[1] as QuerySnapshot;

      return {
        'userProfile': userProfile.data() as Map<String, dynamic>?,
        'allUsers': usersSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList(),
      };
    } catch (e) {
      debugPrint('Failed to fetch data: $e');
      throw Exception('Failed to fetch data');
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
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: fetchUserProfileAndAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data found'));
                  }

                  final userProfile = snapshot.data!['userProfile'];
                  final allUsers =
                      snapshot.data!['allUsers'] as List<Map<String, dynamic>>;

                  final profileImageUrl = userProfile['image_url'];

                  return Expanded(
                    child: Column(
                      children: [
                        Row(
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
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: allUsers.length,
                            itemBuilder: (context, index) {
                              final user = allUsers[index];
                              return UserList(
                                profileImageUrl: user['image_url'],
                                userName: user['nick'],
                                chatPartnerId: user['uid'],
                                lastMessage:
                                    user['lastMessage'] ?? "How did u talk her",
                                lastSeenTime: "2",
                                isOnline: false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
            Provider.of<sign_out.AuthProvider>(context, listen: false)
                .signOut();
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
