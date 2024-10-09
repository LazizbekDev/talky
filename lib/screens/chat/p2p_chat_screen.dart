import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talky/screens/chat/message_box.dart';
import 'package:talky/widgets/chat/profile_bar.dart';

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
              ProfileBar(
                profileImageUrl: widget.chatPartnerImage,
                partnerName: widget.chatPartnerName,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatRooms')
                      .doc(chatRoomId)
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final messages = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message =
                            messages[index].data() as Map<String, dynamic>;
                        final isMe = message['senderId'] ==
                            FirebaseAuth.instance.currentUser!.uid;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MessageBox(
                              sender: isMe,
                              message: message['message'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendMessage(_messageController.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
