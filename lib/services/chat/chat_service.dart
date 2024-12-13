import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talky/services/storage_service.dart';

class ChatService {
  ChatService(this._storageService);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageService _storageService;

  Future<String> initializeChatRoom(String chatPartnerId) async {
    debugPrint('Initializing chat room for partner ID: $chatPartnerId');
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId == null) {
      debugPrint('Error: Current user ID is null.');
      throw Exception('User not logged in');
    }

    final chatRoomId = currentUserId.compareTo(chatPartnerId) > 0
        ? '${chatPartnerId}_$currentUserId'
        : '${currentUserId}_$chatPartnerId';

    debugPrint('Generated ChatRoom ID: $chatRoomId');

    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      debugPrint('Chat room does not exist. Creating new chat room.');
      await chatRoomRef.set({
        'users': [currentUserId, chatPartnerId],
        'lastMessage': '',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } else {
      debugPrint('Chat room already exists.');
    }

    return chatRoomId;
  }

  Future<void> sendMessage({
    required String chatRoomId,
    String? text,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    if (text == null && fileBytes == null) return;

    String? fileUrl;
    if (fileBytes != null && fileName != null) {
      fileUrl = await _storageService.uploadFile(
        'chatFiles/$fileName',
        fileBytes,
      );
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    final currentRoom = _firestore.collection('chatRooms');
    final serverTimeStamp = FieldValue.serverTimestamp();
    await currentRoom.doc(chatRoomId).collection('messages').add({
      'senderId': currentUser?.uid,
      'message': text ?? '',
      'fileUrl': fileUrl ?? '',
      'timestamp': serverTimeStamp,
    });

    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': text ?? (fileUrl != null ? 'File' : ''),
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> fetchMessages(String chatRoomId) async {
    final messagesSnapshot = await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    return messagesSnapshot.docs.map((doc) => doc.data()).toList();
  }

  Stream<String?> getLastMessageStream(
    String chatRoomId,
    String chatPartnerId,
  ) {
    if (chatRoomId.isEmpty || chatPartnerId.isEmpty) {
      debugPrint('Error: chatRoomId or chatPartnerId is empty');
      return Stream.value(null);
    }

    return FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final message = snapshot.docs.first.data();
        if (message.containsKey('text')) {
          return message['text'] as String?;
        } else {
          debugPrint('Warning: "text" field not found in message document');
          return null;
        }
      }
      debugPrint('No messages found in chatRoomId: $chatRoomId');
      return null;
    });
  }
}
