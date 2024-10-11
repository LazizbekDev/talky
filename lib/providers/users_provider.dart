import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  Future<Map<String, dynamic>> fetchUserProfileAndAllUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        debugPrint('User not signed in');
        throw Exception("User not signed in");
      }

      debugPrint('Fetching user profile for: ${currentUser.uid}');
      
      final userProfileFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final allUsersFuture = FirebaseFirestore.instance
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
}
