// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/screens/sign_in.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/button.dart';
import 'package:talky/widgets/logo.dart';
import 'package:talky/widgets/suggest.dart';

class Verify extends StatelessWidget {
  final String? email;
  final String? password;
  const Verify({super.key, this.email, this.password});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (email == null || password == null) {
      return const Scaffold(
        body: Center(
          child: Text("No arguments passed!"),
        ),
      );
    }

    void signUp(pin) async {
      try {
        await authProvider.signUp(
          email: email ?? "",
          password: password ?? "",
          otp: pin,
        );
        Navigator.pushReplacementNamed(context, '/profile');
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
          'Back',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      body: Container(
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
                "Enter the 4 digit codes we send to you",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              OtpPinField(
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
                  signUp(pin);
                },
                onChange: (String text) {},
              ),
              const Spacer(),
              Button(
                onPressed: () {},
                text: "Sign Up",
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
    );
  }
}
