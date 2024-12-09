import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:talky/services/auth/firebase_auth_service.dart';
import 'package:talky/services/auth/firestore_service.dart';
import 'package:talky/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(
    this._authService,
    this._firestoreService,
    this._storageService,
  ) {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;
  final StorageService _storageService;

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

  Future<void> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _user = await _authService.signUp(email, password);
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> signInWithGoogle() async {
    setIsLoading(true);
    try {
      _user = await _authService.signInWithGoogle();
      final uid = _user?.uid ?? '';
      if (_user != null) {
        await _firestoreService.saveUserData(uid, {
          'nick': _user?.displayName,
          'email': _user?.email,
          'image_url': _user?.photoURL,
          'uid': uid,
        });
        notifyListeners();
      }
    } catch (e) {
      handleError(e);
    } finally {
      setIsLoading(false);
      notifyListeners();
    }
  }

  Future<void> uploadUserInfoToFirestore({
    required String nick,
    required dynamic selectedImage,
    String description = '',
  }) async {
    try {
      setIsUploading(true);
      Uint8List imageBytes = await selectedImage.readAsBytes();
      final uid = _user?.uid ?? '';
      final imageUrl = await _storageService.uploadFile(
        'user_images/$uid.jpg',
        imageBytes,
      );

      await _firestoreService.uploadUserProfileImage(
        uid: uid,
        imageUrl: imageUrl,
        nick: nick,
        description: description,
      );

      _profileImageUrl = imageUrl;
      setIsUploading(false);
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      handleError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      handleError(e);
    }
  }

  void handleError(dynamic e) {
    debugPrint('Error: $e');
    throw Exception(e.toString());
  }
}
