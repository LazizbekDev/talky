import 'package:flutter/material.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/screens/chat.dart';
import 'package:talky/screens/set_profile.dart';
import 'package:talky/screens/sign_in.dart';
import 'package:talky/screens/splash.dart';
import 'package:talky/screens/user_entry.dart';
import 'package:talky/screens/verify.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.splash:
      return MaterialPageRoute(builder: (_) => const Splash());

    case RouteNames.auth:
      final args = settings.arguments as bool;
      return MaterialPageRoute(builder: (_) => SignIn(signIn: args));

    case RouteNames.verify:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => Verify(
          email: args?['email'],
          password: args?['password'],
        ),
      );
    case RouteNames.profile:
      return MaterialPageRoute(builder: (_) => const SetProfile());

    case RouteNames.chat:
      return MaterialPageRoute(builder: (_) => const Chat());

    default:
      return MaterialPageRoute(builder: (_) => const UserEntry());
  }
}
