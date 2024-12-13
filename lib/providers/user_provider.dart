import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talky/models/user_model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _user;
  UserModel? get user => _user;

  Future<Map<String, dynamic>> fetchUserProfileAndAllUsers() async {
    try {
      final currentUser = _auth.currentUser;

      if (currentUser == null || currentUser.uid.isEmpty) {
        debugPrint('User not signed in or invalid UID');
        throw Exception("User not signed in or invalid UID");
      }

      debugPrint('Fetching user profile for: ${currentUser.uid}');

      final userProfileFuture =
          _firestore.collection('users').doc(currentUser.uid).get();

      final allUsersFuture = _firestore
          .collection('users')
          .where('uid', isNotEqualTo: currentUser.uid)
          .get();

      final results = await Future.wait([userProfileFuture, allUsersFuture]);

      final userProfile = results.first as DocumentSnapshot;
      final usersSnapshot = results[1] as QuerySnapshot;

      // Validate user profile data
      final userProfileData = userProfile.data() as Map<String, dynamic>?;
      if (userProfileData == null) {
        throw Exception('No user profile found for ${currentUser.uid}');
      }

      // Validate all users data
      final allUsersData = usersSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      debugPrint('User profile fetched: $userProfileData');
      debugPrint('Fetched ${allUsersData.length} other users');

      return {
        'userProfile': userProfileData,
        'allUsers': allUsersData,
      };
    } catch (e) {
      debugPrint('Error while fetching user data: $e');
      throw Exception('Failed to fetch user data');
    }
  }

  Future<UserModel?> fetchUserDetail({required String userId}) async {
    try {
      final fetchId =
          userId == _auth.currentUser?.uid ? _auth.currentUser?.uid : userId;

      final userDoc = await _firestore.collection('users').doc(fetchId).get();

      if (!userDoc.exists) {
        debugPrint('User profile not found');
        return null;
      }

      final data = userDoc.data();

      if (data != null) {
        return UserModel.fromMap(data);
      }

      return null;
    } catch (err) {
      debugPrint('Error fetching user: $err');
      throw Exception('Failed to fetch user data');
    }
  }

  Future<void> updateLastSeenStatus(bool isOnline) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null || userId.isEmpty) return;

    try {
      if (_auth.currentUser != null) {
        final userDoc = _firestore.collection('users').doc(userId);

        await userDoc.update({
          'lastSeen': FieldValue.serverTimestamp(),
          'isOnline': isOnline,
        });
      }
    } catch (e) {
      debugPrint('Error updating last seen status: $e');
    }
  }

  Future<DateTime?> fetchUserLastSeen(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data();
    if (userDoc.exists) {
      final isOnline = userData?['isOnline'] as bool? ?? false;
      if (isOnline) return null;
      return (userData?['lastSeen'] as Timestamp?)?.toDate();
    }
    return null;
  }
}
