import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _messages = [];
  final List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get messages => _messages;
  List<Map<String, dynamic>> get users => _users;

  String chatRoomId = '';

  Future<void> initializeChatRoom(String chatPartnerId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (currentUserId.compareTo(chatPartnerId) > 0) {
      chatRoomId = '${chatPartnerId}_$currentUserId';
    } else {
      chatRoomId = '${currentUserId}_$chatPartnerId';
    }

    final chatRoomRef = _firestore.collection('chatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      await chatRoomRef.set({
        'users': [currentUserId, chatPartnerId],
        'lastMessage': '',
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    }

    notifyListeners();
  }

  Stream<String?> getLastMessage(String chatPartnerId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    final chatRoomId = currentUserId.compareTo(chatPartnerId) > 0
        ? '${chatPartnerId}_$currentUserId'
        : '${currentUserId}_$chatPartnerId';

    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return snapshot.data()!['lastMessage'] as String?;
      }
      return null;
    });
  }

  Stream<Map<String, dynamic>> userStatusStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.data() ?? {};
    });
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      var refStorage = FirebaseStorage.instance
          .ref()
          .child('chatImages')
          .child('chat_image_$fileName.png');

      Uint8List imageBytes = await imageFile.readAsBytes();
      var uploadTask = await refStorage.putData(imageBytes);
      String imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint('Failed to upload image: $e');
      return null;
    }
  }

  Future<void> sendMessage({String? text, String? imageUrl}) async {
    if (text == null && imageUrl == null) return;

    final currentUser = FirebaseAuth.instance.currentUser;

    await _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'senderId': currentUser!.uid,
      'message': text ?? '',
      'imageUrl': imageUrl ?? '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chatRooms').doc(chatRoomId).update({
      'lastMessage': text ?? 'Image',
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    notifyListeners();
  }

  Future<void> fetchChatData(String chatRoomId) async {
    try {
      final messagesSnapshot = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      _messages = messagesSnapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch chat data: $e');
    }
  }
}
