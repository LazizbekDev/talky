import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:talky/firebase_options.dart';
import 'package:talky/screens/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}
 