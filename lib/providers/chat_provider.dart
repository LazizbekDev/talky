import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get messages => _messages;
  List<Map<String, dynamic>> get users => _users;

  Future<void> fetchChatData(String userId) async {
    try {
      final messagesSnapshot = await _firestore
          .collection('chats')
          .doc(userId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      _messages = messagesSnapshot.docs
          .map((doc) => doc.data())
          .toList();

      final usersSnapshot = await _firestore.collection('users').get();
      _users = usersSnapshot.docs
          .map((doc) => doc.data())
          .toList();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch chat data: $e');
    }
  }
}
