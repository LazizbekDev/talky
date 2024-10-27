import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> fetchUserProfileAndAllUsers() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null) {
        debugPrint('User not signed in');
        throw Exception("User not signed in");
      }

      debugPrint('Fetching user profile for: ${currentUser.uid}');

      final userProfileFuture =
          _firestore.collection('users').doc(currentUser.uid).get();

      final allUsersFuture = _firestore
          .collection('users')
          .where('uid', isNotEqualTo: currentUser.uid)
          .get();

      final results = await Future.wait([userProfileFuture, allUsersFuture]);

      final userProfile = results[0] as DocumentSnapshot;
      final usersSnapshot = results[1] as QuerySnapshot;

      debugPrint('User profile: ${userProfile.data()}');
      debugPrint('Fetched ${usersSnapshot.docs.length} users');

      return {
        'userProfile': userProfile.data() as Map<String, dynamic>?,
        'allUsers': usersSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList(),
      };
    } catch (e) {
      debugPrint('Error while fetching user data: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> updateLastSeenStatus(bool isOnline) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _firestore.collection('users').doc(userId).update({
      'lastSeen': FieldValue.serverTimestamp(),
      'isOnline': isOnline,
    });
  }

  Future<DateTime?> fetchUserLastSeen(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      final isOnline = userDoc.data()?['isOnline'] as bool? ?? false;
      if (isOnline) return null;
      return (userDoc.data()?['lastSeen'] as Timestamp?)?.toDate();
    }
    return null;
  }
}
