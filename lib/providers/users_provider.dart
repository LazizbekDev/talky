import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchAllUsers(String currentUserId) async {
    try {
      final usersSnapshot = await _firestore
          .collection('users')
          .where('uid', isNotEqualTo: currentUserId)
          .get();

      return usersSnapshot.docs
          .map((doc) => doc.data())
          .toList(); 
    } catch (e) {
      debugPrint('Failed to fetch users: $e');
      return [];
    }
  }
}
