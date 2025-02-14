import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';
import 'package:talky/localization/localization.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/screens/login/sign_in.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/button.dart';
import 'package:talky/widgets/logo.dart';
import 'package:talky/widgets/login/suggest.dart';

class Verify extends StatelessWidget {
  const Verify({
    super.key,
    this.email,
    this.password,
  });
  final String? email;
  final String? password;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final textInter = GoogleFonts.inter();
    final locale = context.locale;

    if (email == null || password == null) {
      return const Scaffold(
        body: Center(
          child: Text("No arguments passed!"),
        ),
      );
    }

    void signUp(context) async {
      try {
        await authProvider.signUp(
          email: email ?? "",
          password: password ?? "",
        );
        Navigator.pushReplacementNamed(context, RouteNames.profile);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: AppColors.secondaryColor,
          icon: Image.asset(
            "assets/images/pop.png",
            width: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          locale.back,
          style: textInter.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                Text(
                  locale.enterOTP,
                  style: textInter.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: OtpPinField(
                    maxLength: 4,
                    fieldWidth: 50.0,
                    otpPinFieldStyle: const OtpPinFieldStyle(
                      defaultFieldBorderColor: AppColors.lightGray,
                      activeFieldBorderColor: AppColors.primaryColor,
                      fieldBorderRadius: 8,
                    ),
                    keyboardType: TextInputType.number,
                    otpPinFieldDecoration:
                        OtpPinFieldDecoration.defaultPinBoxDecoration,
                    onSubmit: (String pin) {
                      signUp(context);
                    },
                    onChange: (String text) {
                      debugPrint("verify onChange");
                    },
                  ),
                ),
                Button(
                  onPressed: () {
                    debugPrint("Sign up button");
                  },
                  text: locale.signUp,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                Suggest(
                  login: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => SignIn(
                          signIn: true,
                        ),
                      ),
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
