import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

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
      throw Exception(e.toString());
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
        email: email,
        password: password,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('$e');
      throw Exception(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];
    GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: scopes).signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        _user = userCredential.user;
        notifyListeners();
      } catch (e) {
        if (e is FirebaseAuthException) {
          debugPrint('Error: ${e.message}');
        }
        throw Exception(e.toString());
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
