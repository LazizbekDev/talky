import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:talky/providers/chat_provider.dart';
import 'package:talky/providers/user_provider.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/chat/user_list.dart';

class ChatModal extends StatelessWidget implements PreferredSizeWidget {
  const ChatModal({
    super.key,
    required this.title,
    this.complete = false,
    required this.controller,
  });
  final String title;
  final bool complete;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final TextEditingController groupController = TextEditingController();
    final textStyle = GoogleFonts.inter();
    final mainTextStyle = textStyle.copyWith(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: AppBar(
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: Text(
                  'Cancel',
                  style: mainTextStyle,
                ),
              ),
            ),
            leadingWidth: 60,
            title: Text(
              title,
              style: textStyle.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            actions: [
              complete
                  ? TextButton(
                      onPressed: () {
                        debugPrint("Chat Model, saved");
                      },
                      child: Text(
                        'Done',
                        style: mainTextStyle,
                      ),
                    )
                  : const SizedBox(),
            ],
            centerTitle: true,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 28,
          right: 28,
          top: 10,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: textStyle.copyWith(
                    color: AppColors.lightGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.lightGray),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    color: AppColors.lightGray,
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isNotEmpty) {
                        controller.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFF0F0F0),
                  radius: 20,
                  child: Icon(
                    Icons.people_alt_rounded,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
                title: GestureDetector(
                  onTap: () => showCupertinoModalBottomSheet(
                    topRadius: const Radius.circular(10),
                    context: context,
                    builder: (context) => ChatModal(
                      title: 'Group',
                      complete: true,
                      controller: groupController,
                    ),
                  ),
                  child: Text(
                    'Start a new group chat',
                    style: textStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
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

                final data = snapshot.data;
                if (data == null || data['allUsers'] == null) {
                  return const Center(child: Text('No data found'));
                }
                final allUsers = data['allUsers'];

                if (allUsers.isEmpty) {
                  return const Center(child: Text('No users available'));
                }
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      final user = allUsers[index];
                      final chatPartnerId = user['uid'];

                      return StreamBuilder<String?>(
                        stream:
                            Provider.of<ChatProvider>(context, listen: false)
                                .getLastMessage(chatPartnerId),
                        builder: (context, lastMessageSnapshot) {
                          return FutureBuilder<DateTime?>(
                            future:
                                userProvider.fetchUserLastSeen(chatPartnerId),
                            builder: (context, lastSeenSnapshot) {
                              if (lastSeenSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Align(
                                  alignment: Alignment.topRight,
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (lastSeenSnapshot.hasError) {
                                return const Text('Error loading status');
                              }

                              final lastSeenTime = lastSeenSnapshot.data;
                              final statusText = lastSeenTime == null
                                  ? 'Online'
                                  : DateFormat('dd MMM, HH:mm')
                                      .format(lastSeenTime);

                              return UserList(
                                profileImageUrl: user['image_url'],
                                userName: user['nick'],
                                bio: user?['description'] ?? "",
                                chatPartnerId: chatPartnerId,
                                lastMessage: user?['description'] ?? "",
                                isOnline: statusText == 'Online',
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
