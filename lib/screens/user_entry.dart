import 'package:flutter/material.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/divider.dart';
import 'package:talky/widgets/logo.dart';
import 'package:talky/widgets/suggest.dart';

class UserEntry extends StatelessWidget {
  const UserEntry({super.key});

  @override
  Widget build(BuildContext context) {
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
                MaterialButton(
                  onPressed: () {},
                  color: AppColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minWidth: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/iconGoogle.png',
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text('Sign in with Google'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 38,
                ),
                const DividerWithText(),
                const SizedBox(
                  height: 38,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.auth);
                  },
                  color: AppColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minWidth: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/lets-icons_e-mail.png',
                        height: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text('Continue with main'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 38,
                ),
                const Suggest(
                  login: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
