import 'package:flutter/material.dart';
import 'package:talky/providers/auth_provider.dart' as sign_out;
import 'package:provider/provider.dart';
import 'package:talky/providers/users_provider.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/chat/user_list.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<Map<String, dynamic>>(
                future: userProvider.fetchUserProfileAndAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data found'));
                  }

                  final userProfile = snapshot.data!['userProfile'];
                  final allUsers = snapshot.data!['allUsers'];

                  if (userProfile == null || allUsers.isEmpty) {
                    return const Center(child: Text('No users available'));
                  }

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
                              userProfile['nick'] ?? 'User',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search, size: 20),
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
                                    user['lastMessage'] ?? "No message yet",
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
