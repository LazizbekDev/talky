import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String nick;
  String description;
  String imageUrl;
  DateTime lastSeen;
  bool isOnline;

  UserModel({
    required this.uid,
    required this.nick,
    required this.description,
    required this.imageUrl,
    required this.lastSeen,
    required this.isOnline,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] ?? '',
      nick: data['nick'] ?? 'Unknown',
      description: data['description'] ?? '',
      imageUrl: data['image_url'] ?? '',
      lastSeen: data['lastSeen'] is Timestamp
          ? (data['lastSeen'] as Timestamp)
              .toDate()
          : DateTime.now(),
      isOnline: data['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nick': nick,
      'description': description,
      'image_url': imageUrl,
      'lastSeen': lastSeen,
      'isOnline': isOnline,
    };
  }
}
