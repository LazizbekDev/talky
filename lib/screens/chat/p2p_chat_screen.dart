import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/status/provider_status.dart';
import 'package:talky/widgets/chat/message_box.dart';
import 'package:talky/widgets/chat/profile_bar.dart';
import 'package:talky/widgets/chat/send_data.dart';
import 'package:talky/providers/chat_provider.dart';
import 'package:intl/intl.dart';

class P2PChatScreen extends StatefulWidget {
  const P2PChatScreen({
    super.key,
    required this.chatPartnerId,
    required this.chatPartnerName,
    required this.chatPartnerImage,
    required this.bio,
    required this.onlineStatus,
  });
  final String chatPartnerId;
  final String chatPartnerName;
  final String chatPartnerImage;
  final String bio;
  final String onlineStatus;

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

      Uint8List imageBytes = await imageFile.readAsBytes();

      String? imageUrl = await chatProvider.uploadImage(imageBytes);

      if (imageUrl != null && mounted) {
        await chatProvider.sendMessage(
          fileBytes: imageBytes,
          fileName: imageUrl,
          chatPartnerId: widget.chatPartnerId,
        );
      }
    } else {
      debugPrint('No image selected');
    }
  }

  Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      return result.files.first;
    }
    return null;
  }

  String extractFileType(String fileUrl) {
    try {
      final uri = Uri.parse(fileUrl);
      final path = uri.path;
      if (path.contains('.png')) {
        return 'image';
      }
      return 'file';
    } catch (e) {
      return 'file';
    }
  }

  @override
  Widget build(BuildContext context) {
    List allImages = [];
    return Scaffold(
      appBar: ProfileBar(
        profileImageUrl: widget.chatPartnerImage,
        partnerName: widget.chatPartnerName,
        onlineStatus: widget.onlineStatus,
        onPress: () {
          Navigator.pushNamed(
            context,
            RouteNames.profileDetail,
            arguments: {
              'userId': widget.chatPartnerId,
              'imageUrls': allImages.cast<String>(),
            },
          );
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
                child: Consumer<ChatProvider>(
                  builder: (
                    context,
                    provider,
                    child,
                  ) {
                    if (provider.getChatDetailStatus ==
                        ProviderStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (provider.getChatDetailStatus ==
                        ProviderStatus.error) {
                      return const Center(child: Text('Error loading chat'));
                    } else if (provider.getChatDetailStatus ==
                        ProviderStatus.loaded) {
                      return StreamBuilder(
                        stream: provider.messages,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final List<Map<String, dynamic>>? messages =
                              snapshot.data;
                          String? previousDate;

                          return ListView.builder(
                            reverse: true,
                            itemCount: messages?.length,
                            itemBuilder: (context, index) {
                              final message = messages?[index];
                              final String fileUrl = message?['fileUrl'] ?? "";

                              final bool isImage =
                                  extractFileType(fileUrl) == 'image';

                              final List<String> imageUrls =
                                  isImage ? [fileUrl] : [];

                              if (isImage) {
                                allImages.add(fileUrl);
                              }

                              final isMe = message?['senderId'] ==
                                  FirebaseAuth.instance.currentUser?.uid;
                              final Timestamp? timestamp =
                                  message?['timestamp'] as Timestamp?;

                              DateTime messageDate = timestamp != null
                                  ? timestamp.toDate()
                                  : DateTime.now();

                              final String formattedDate =
                                  DateFormat('MMM dd, yyyy')
                                      .format(messageDate);

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
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
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
                                        message: message?['message'] ?? '',
                                        timestamp: messageDate,
                                        imageUrls: imageUrls,
                                        fileUrl: isImage ? '' : fileUrl,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
              SendData(
                sendToChat: ({String? text, String? imageUrl}) async {
                  if (text != null && text.isNotEmpty) {
                    await Provider.of<ChatProvider>(context, listen: false)
                        .sendMessage(
                      text: text,
                      chatPartnerId: widget.chatPartnerId,
                    );
                  }

                  if (imageUrl != null) {
                    final fileResult = await pickFile();
                    if (fileResult != null && context.mounted) {
                      await Provider.of<ChatProvider>(context, listen: false)
                          .sendMessage(
                        chatPartnerId: widget.chatPartnerId,
                        fileBytes: fileResult.bytes,
                        fileName: fileResult.name,
                      );
                    }
                  }
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
