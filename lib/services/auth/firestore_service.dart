import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(String uid, Map<String, dynamic> userData) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .set(userData, SetOptions(merge: true));
  }

  Future<void> uploadUserProfileImage({
    required String uid,
    required String imageUrl,
    required String nick,
    String description = '',
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'image_url': imageUrl,
      'nick': nick,
      'description': description,
    }, SetOptions(merge: true));
  }
}
