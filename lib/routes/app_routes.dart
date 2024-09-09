import 'package:flutter/material.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/screens/sign_in.dart';
import 'package:talky/screens/home.dart';
import 'package:talky/screens/splash.dart';
import 'package:talky/screens/verify.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.splash:
      return MaterialPageRoute(builder: (_) => const Splash());

    case RouteNames.home:
      return MaterialPageRoute(builder: (_) => const Home());

    case RouteNames.auth:
      return MaterialPageRoute(builder: (_) => SignIn(signIn: true));

    case RouteNames.verify:
      return MaterialPageRoute(builder: (_) => const Verify());

    default:
      return MaterialPageRoute(builder: (_) => const Home());
  }
}
