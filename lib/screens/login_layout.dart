import 'package:flutter/material.dart';
import 'package:talky/widgets/logo.dart';

class LoginLayout extends StatelessWidget {
  final Widget caption;
  final Widget email;
  final Widget password;
  final Widget forgotPassword;
  final Widget agreement;
  final Widget button;
  final Widget suggestion;

  const LoginLayout({
    super.key,
    required this.caption,
    required this.email,
    required this.password,
    this.forgotPassword = const SizedBox(),
    this.agreement = const SizedBox(),
    required this.button,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 28,
        top: 26,
        right: 28,
        bottom: 100,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Logo(
              dark: true,
            ),
            const SizedBox(
              height: 40,
            ),
            caption,
            const SizedBox(
              height: 40,
            ),
            email,
            const SizedBox(
              height: 18,
            ),
            password,
            const SizedBox(
              height: 18,
            ),
            forgotPassword,
            const SizedBox(
              height: 40,
            ),
            agreement,
            const Spacer(),
            button,
            const SizedBox(
              height: 30,
            ),
            suggestion,
          ],
        ),
      ),
    );
  }
}
