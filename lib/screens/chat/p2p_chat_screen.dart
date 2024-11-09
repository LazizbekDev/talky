import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/widgets/chat/message_box.dart';
import 'package:talky/widgets/chat/profile_bar.dart';
import 'package:talky/widgets/chat/send_data.dart';
import 'package:talky/providers/chat_provider.dart';
import 'package:intl/intl.dart';

class P2PChatScreen extends StatefulWidget {
  final String chatPartnerId;
  final String chatPartnerName;
  final String chatPartnerImage;
  final String bio;
  final String onlineStatus;

  const P2PChatScreen({
    super.key,
    required this.chatPartnerId,
    required this.chatPartnerName,
    required this.chatPartnerImage,
    required this.bio,
    required this.onlineStatus,
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
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      File imageFile = File(pickedFile.path);
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);

      String? imageUrl = await chatProvider.uploadImage(imageFile);

      if (imageUrl != null && mounted) {
        await chatProvider.sendMessage(imageUrl: imageUrl);
      }
    } else {
      debugPrint('No image selected');
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(withData: true);

    if (result != null && mounted) {
      Uint8List? fileBytes = result.files.single.bytes;
      String fileName = result.files.single.name;

      if (fileBytes == null) {
        File file = File(result.files.single.path!);
        fileBytes = await file.readAsBytes();
      }
      if (!mounted) return;
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      String? fileUrl = await chatProvider.uploadFile(fileBytes, fileName);

      if (fileUrl != null && mounted) {
        await chatProvider.sendMessage(fileUrl: fileUrl);
      }
    } else {
      debugPrint('No file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    List allImages = [];
    return Scaffold(
      appBar: ProfileBar(
        profileImageUrl: widget.chatPartnerImage,
        partnerName: widget.chatPartnerName,
        onlineStatus: widget.onlineStatus,
        onPress: () {
          Navigator.pushNamed(context, RouteNames.profileDetail, arguments: {
            'imageUrl': widget.chatPartnerImage,
            'nick': widget.chatPartnerName,
            'bio': widget.bio,
            'lastSeen': widget.onlineStatus,
            'imageUrls': allImages.cast<String>()
          });
        },
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
                        final String imageUrl = message['imageUrl'] ?? '';
                        final String fileUrl = message['fileUrl'] ?? '';

                        List<String> imageUrls = [];
                        if (imageUrl.isNotEmpty) {
                          imageUrls.add(imageUrl);
                          allImages.add(imageUrl);
                        }
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
                                  imageUrls: imageUrls,
                                  fileUrl: fileUrl,
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
                chooseFile: pickFile,
                controller: _messageController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
