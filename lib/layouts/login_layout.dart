import 'package:flutter/material.dart';
import 'package:talky/widgets/logo.dart';

class LoginLayout extends StatelessWidget {
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
  final Widget caption;
  final Widget email;
  final Widget password;
  final Widget forgotPassword;
  final Widget agreement;
  final Widget button;
  final Widget suggestion;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 28,
                top: 20,
                right: 28,
                bottom: 50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Logo(
                    dark: true,
                  ),
                  caption,
                  email,
                  password,
                  forgotPassword,
                  const SizedBox(
                    height: 40,
                  ),
                  const Spacer(),
                  button,
                  const SizedBox(
                    height: 30,
                  ),
                  suggestion,
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
