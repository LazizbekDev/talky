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

    final userDoc = _firestore.collection('users').doc(userId);
    int retryCount = 0;
    const maxRetries = 5;

    while (retryCount < maxRetries) {
      try {
        final userSnapshot = await userDoc.get();

        // Check if the user document exists, create it if not
        if (!userSnapshot.exists) {
          await userDoc.set({
            'lastSeen': FieldValue.serverTimestamp(),
            'isOnline': isOnline,
            'profileSet': false,
          });
        } else {
          await userDoc.update({
            'lastSeen': FieldValue.serverTimestamp(),
            'isOnline': isOnline,
          });
        }
        // If successful, break out of the loop
        break;
      } catch (e) {
        if (e is FirebaseException && e.code == 'unavailable') {
          retryCount++;
          await Future.delayed(Duration(milliseconds: 200 * (1 << retryCount)));
          continue; // Retry after the delay
        } else {
          debugPrint('Failed to update last seen status: $e');
          break; // Exit if the error is not due to a transient condition
        }
      }
    }
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
