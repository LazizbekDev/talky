// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talky/localization/localization.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/providers/localization_provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/button.dart';
import 'package:talky/widgets/divider_with_text.dart';
import 'package:talky/widgets/logo.dart';
import 'package:talky/widgets/login/suggest.dart';

class UserEntry extends StatelessWidget {
  const UserEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final localizationProvider = Provider.of<LocalizationProvider>(context);
    void signIn(authProvider) async {
      try {
        await authProvider.signInWithGoogle();

        if (authProvider.user != null && context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            RouteNames.chat,
          );
        } else {
          debugPrint('Sign in failed: User is null');
        }
      } catch (e) {
        debugPrint('Error during sign-in: $e');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(locale.signInError),
            ),
          );
        }
      }
    }

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
                Consumer<AuthProvider>(
                  builder: (
                    context,
                    authProvider,
                    child,
                  ) {
                    return MaterialButton(
                      onPressed: () => signIn(authProvider),
                      color: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      minWidth: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (authProvider.loading) ...[
                            const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.black,
                              ),
                            ),
                          ] else ...[
                            Image.asset(
                              'assets/images/iconGoogle.png',
                              height: 24,
                            ),
                            const SizedBox(width: 25),
                            Text(
                              locale.googleSignIn,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 38,
                ),
                DividerWithText(
                  text: locale.or,
                ),
                const SizedBox(
                  height: 38,
                ),
                Button(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.auth,
                      arguments: true,
                    );
                  },
                  text: locale.withEmail,
                  imagePath: 'assets/images/lets-icons_e-mail.png',
                  color: AppColors.backgroundColor,
                ),
                const SizedBox(
                  height: 38,
                ),
                DropdownButton<String>(
                  value: localizationProvider.locale.languageCode,
                  icon: const Icon(Icons.language),
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'uz', child: Text('O‘zbekcha')),
                    DropdownMenuItem(value: 'ru', child: Text('Русский')),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      localizationProvider.setLocale(value);
                    }
                  },
                ),
                const SizedBox(
                  height: 38,
                ),
                Suggest(
                  login: true,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.auth,
                      arguments: false,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
