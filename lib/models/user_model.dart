class UserModel {
  String uid;
  String nickname;
  String bio;
  String profilePictureUrl;

  UserModel({
    required this.uid,
    required this.nickname,
    required this.bio,
    required this.profilePictureUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      nickname: data['nickname'],
      bio: data['bio'],
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nickname': nickname,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
