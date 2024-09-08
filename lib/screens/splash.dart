import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:talky/screens/user_entry.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/logo.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      duration: const Duration(milliseconds: 3000),
      nextScreen: const UserEntry(),
      backgroundColor: AppColors.primaryColor,
      childWidget: const Center(
        child: Logo(
          dark: false,
        ),
      ),
    );
  }
}
