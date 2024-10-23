import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:talky/screens/chat/message_box.dart';
import 'package:talky/widgets/chat/profile_bar.dart';
import 'package:talky/widgets/chat/send_data.dart';
import 'package:talky/providers/chat_provider.dart';
import 'package:intl/intl.dart';

class P2PChatScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;
  final String chatPartnerImage;

  const P2PChatScreen({
    super.key,
    required this.chatPartnerId,
    required this.chatPartnerName,
    required this.chatPartnerImage,
  });

  @override
  State<P2PChatScreen> createState() => _P2PChatScreenState();
}

class _P2PChatScreenState extends State<P2PChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false)
        .initializeChatRoom(widget.chatPartnerId);
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 150,
    );

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      if (!mounted) return;
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      String? imageUrl = await chatProvider.uploadImage(imageFile);

      if (imageUrl != null && mounted) {
        await chatProvider.sendMessage(imageUrl: imageUrl);
      }
    } else {
      debugPrint('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: ProfileBar(
        profileImageUrl: widget.chatPartnerImage,
        partnerName: widget.chatPartnerName,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 21,
            right: 21,
            bottom: 31,
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chatRooms')
                      .doc(chatProvider.chatRoomId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!.docs;
                    String? previousDate;

                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index].data();
                        final isMe = message['senderId'] ==
                            FirebaseAuth.instance.currentUser!.uid;
                        final Timestamp? timestamp =
                            message['timestamp'] as Timestamp?;

                        DateTime messageDate = timestamp != null
                            ? timestamp.toDate()
                            : DateTime.now();

                        final String formattedDate =
                            DateFormat('MMM dd, yyyy').format(messageDate);

                        bool showDateHeader = false;
                        debugPrint(
                            "Image url in screen: ${message['imageUrl']}");

                        if (previousDate == null ||
                            previousDate != formattedDate) {
                          showDateHeader = true;
                          previousDate = formattedDate;
                        }

                        return Column(
                          children: [
                            if (showDateHeader)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MessageBox(
                                  sender: isMe,
                                  message: message['message'] ?? '',
                                  timestamp: messageDate,
                                  imageUrl: message['imageUrl'],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SendData(
                sendToChat: ({String? text, String? imageUrl}) {
                  Provider.of<ChatProvider>(context, listen: false)
                      .sendMessage(text: text, imageUrl: imageUrl);
                },
                chooseImage: pickImage,
                controller: _messageController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
