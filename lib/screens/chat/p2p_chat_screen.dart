import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:talky/screens/chat/message_box.dart';
import 'package:talky/widgets/chat/profile_bar.dart';
import 'package:talky/widgets/chat/send_data.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  String chatRoomId = '';

  @override
  void initState() {
    super.initState();
    _initializeChatRoom();
  }

  Future<void> _initializeChatRoom() async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final partnerId = widget.chatPartnerId;

    if (currentUserId.compareTo(partnerId) > 0) {
      chatRoomId = '${partnerId}_$currentUserId';
    } else {
      chatRoomId = '${currentUserId}_$partnerId';
    }

    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      chatRoomRef.set({
        'users': [currentUserId, partnerId],
        'lastMessage': '',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }

    setState(() {});
  }

  Future<void> _sendMessage(String message) async {
    if (message.isEmpty) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);
    final messagesRef = chatRoomRef.collection('messages');

    await messagesRef.add({
      'senderId': currentUser!.uid,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await chatRoomRef.update({
      'lastMessage': message,
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatRooms')
                      .doc(chatRoomId)
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
                        final message =
                            messages[index].data() as Map<String, dynamic>;
                        final isMe = message['senderId'] ==
                            FirebaseAuth.instance.currentUser!.uid;
                        final Timestamp timestamp = message['timestamp'];
                        final DateTime messageDate = timestamp.toDate();
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
                                  message: message['message'],
                                  timestamp: message['timestamp'],
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
                sendToChat: _sendMessage,
                controller: _messageController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
