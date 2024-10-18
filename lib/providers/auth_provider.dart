import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _loading = false;
  bool _isUploading = false;
  String? _profileImageUrl;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get loading => _loading;
  bool get isUploading => _isUploading;
  String? get profileImageUrl => _profileImageUrl;

  void setIsUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String otp,
  }) async {
    try {
      bool isVerified = EmailOTP.verifyOTP(otp: otp);
      if (!isVerified) {
        throw Exception('Invalid OTP. Please try again.');
      }
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> signInWithGoogle() async {
    setIsLoading(true);
    try {
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        _user = userCredential.user;
        await _saveUserDataToFirestore();
        notifyListeners();
      }
    } catch (e) {
      handleError(e);
    } finally {
      setIsLoading(false);
      notifyListeners();
    }
  }

  Future<void> _saveUserDataToFirestore() async {
    if (_user != null) {
      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
        'nick': _user?.displayName,
        'email': _user?.email,
        'image_url': _user?.photoURL,
        'uid': _user?.uid,
      }, SetOptions(merge: true));
    }
  }

  Future<void> uploadUserInfoToFirestore(
      {required String nick,
      required dynamic selectedImage,
      String description = ''}) async {
    try {
      setIsUploading(true);
      if (nick.isEmpty) {
        throw Exception('Please enter your nickname.');
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${_user!.uid}.jpg');

      await storageRef.putFile(selectedImage);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(_user!.uid).set({
        'email': _user?.email,
        'image_url': imageUrl,
        'nick': nick,
        'description': description,
        'uid': user?.uid,
      });

      _profileImageUrl = imageUrl;
      setIsUploading(false);
      notifyListeners();
    } catch (err) {
      handleError(err);
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      handleError(e);
    }
  }

  void handleError(dynamic e) {
    debugPrint('Error: $e');
    throw Exception(e.toString());
  }
}
