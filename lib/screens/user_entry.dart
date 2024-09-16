// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/button.dart';
import 'package:talky/widgets/divider.dart';
import 'package:talky/widgets/logo.dart';
import 'package:talky/widgets/suggest.dart';

class UserEntry extends StatelessWidget {
  const UserEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.middleGray,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28, vertical: 100),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Logo(
                  dark: true,
                ),
                const Spacer(),
                Button(
                  onPressed: () async {
                    try {
                      await authProvider.signInWithGoogle();

                      if (authProvider.user != null) {
                        Navigator.pushReplacementNamed(
                            context, RouteNames.home);
                      } else {
                        debugPrint('Sign in failed');
                      }
                    } catch (e) {
                      debugPrint('$e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sign-in failed. Please try again.'),
                        ),
                      );
                    }
                  },
                  text: 'Sign in with Google',
                  imagePath: 'assets/images/iconGoogle.png',
                  color: AppColors.backgroundColor,
                ),
                const SizedBox(
                  height: 38,
                ),
                const DividerWithText(),
                const SizedBox(
                  height: 38,
                ),
                Button(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.auth, arguments: true);
                  },
                  text: 'Continue with Email',
                  imagePath: 'assets/images/lets-icons_e-mail.png',
                  color: AppColors.backgroundColor,
                ),
                const SizedBox(
                  height: 38,
                ),
                Suggest(
                  login: true,
                  onTap: () {
                    Navigator.pushNamed(context, RouteNames.auth, arguments: false);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
