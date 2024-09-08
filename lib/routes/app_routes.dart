import 'package:flutter/material.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/screens/sign_in.dart';
import 'package:talky/screens/home.dart';
import 'package:talky/screens/splash.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.splash:
      return MaterialPageRoute(builder: (_) => const Splash());
    case RouteNames.home:
      return MaterialPageRoute(builder: (_) => const Home());
    case RouteNames.auth:
      return MaterialPageRoute(builder: (_) => const SignIn());
    // case RouteNames.chat:
    //   final chatArgs = settings.arguments as ChatArgs;
    //   return MaterialPageRoute(builder: (_) => ChatScreen(args: chatArgs));
    // case RouteNames.group:
    //   return MaterialPageRoute(builder: (_) => GroupScreen());
    // case RouteNames.usersList:
    //   return MaterialPageRoute(builder: (_) => UsersListScreen());
    default:
      return MaterialPageRoute(builder: (_) => const Home());
  }
}
