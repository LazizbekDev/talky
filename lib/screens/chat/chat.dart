import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:talky/providers/auth_provider.dart' as sign_out;
import 'package:provider/provider.dart';
import 'package:talky/providers/chat_provider.dart';
import 'package:talky/providers/user_provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/utilities/lifecycle_observer.dart';
import 'package:talky/widgets/chat/chat_modal.dart';
import 'package:talky/widgets/chat/user_list.dart';

class Chat extends StatelessWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController contactController = TextEditingController();

    final userProvider = Provider.of<UserProvider>(context);
    WidgetsBinding.instance.addObserver(LifecycleObserver(userProvider));
    userProvider.updateLastSeenStatus(true);

    Future<void> onLogOut(BuildContext context) async {
      await userProvider.updateLastSeenStatus(false);
      if (!context.mounted) return;
      await Provider.of<sign_out.AuthProvider>(context, listen: false)
          .signOut();
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.splash);
    }

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
                    return const Align(
                      alignment: Alignment.topRight,
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('No data found'));
                  }

                  final userProfile = snapshot.data?['userProfile'];
                  final allUsers = snapshot.data?['allUsers'];

                  if (allUsers.isEmpty) {
                    return const Center(child: Text('No users available'));
                  }

                  if (userProfile == null) {
                    Navigator.pushReplacementNamed(context, RouteNames.profile);
                  }

                  final profileImageUrl = userProfile['image_url'];

                  return Expanded(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.profileDetail,
                              arguments: {
                                'userId': userProfile['uid'],
                                'imageUrls': <String>[],
                              },
                            );
                          },
                          child: Row(
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
                                onPressed: () => onLogOut(context),
                                icon: const Icon(Icons.search, size: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: allUsers.length,
                            itemBuilder: (context, index) {
                              final user = allUsers[index];
                              final chatPartnerId = user['uid'];

                              return StreamBuilder<String?>(
                                stream: Provider.of<ChatProvider>(
                                  context,
                                  listen: false,
                                ).getLastMessage(chatPartnerId),
                                builder: (context, lastMessageSnapshot) {
                                  final lastMessage = lastMessageSnapshot.data;

                                  return FutureBuilder<DateTime?>(
                                    future: userProvider
                                        .fetchUserLastSeen(chatPartnerId),
                                    builder: (context, lastSeenSnapshot) {
                                      if (lastSeenSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (lastSeenSnapshot.hasError) {
                                        return const Text(
                                          'Error loading status',
                                        );
                                      }

                                      final lastSeenTime =
                                          lastSeenSnapshot.data;
                                      final statusText = lastSeenTime == null
                                          ? 'Online'
                                          : DateFormat('dd MMM, HH:mm')
                                              .format(lastSeenTime);

                                      return lastMessage != ''
                                          ? UserList(
                                              profileImageUrl:
                                                  user['image_url'],
                                              userName: user['nick'],
                                              bio: user?['description'] ?? "",
                                              chatPartnerId: chatPartnerId,
                                              lastMessage: lastMessage,
                                              lastSeenTime: statusText,
                                              isOnline: statusText == 'Online',
                                            )
                                          : const SizedBox.shrink();
                                    },
                                  );
                                },
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
          onPressed: () => showCupertinoModalBottomSheet(
            topRadius: const Radius.circular(10),
            context: context,
            builder: (context) => ChatModal(
              title: 'Chat',
              complete: !true,
              controller: contactController,
            ),
          ),
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
