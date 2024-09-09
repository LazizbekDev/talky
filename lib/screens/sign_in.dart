// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/layouts/login_layout.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/utilities/status.dart';
import 'package:talky/widgets/agreement.dart';
import 'package:talky/widgets/button.dart';
import 'package:talky/widgets/forgot_password.dart';
import 'package:talky/widgets/input.dart';
import 'package:talky/widgets/suggest.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  bool signIn = true;
  bool termAndConditions = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

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
      body: LoginLayout(
        caption: Text(
          "Sign ${signIn ? "in" : "up"} with mail",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        email: Input(
          obscureText: false,
          controller: _emailController,
          hintText: 'Email',
        ),
        password: Input(
          controller: _passwordController,
          obscureText: _obscureText,
          hintText: 'Enter ${signIn ? 'your' : 'new'} password',
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: _togglePasswordVisibility,
          ),
        ),
        forgotPassword: signIn
            ? ForgotPassword(
                onPressed: () {},
              )
            : Agreement(
                isChecked: termAndConditions,
                onChanged: (bool? e) {
                  setState(() {
                    termAndConditions = e ?? false;
                  });
                },
                onTermsPressed: () {
                  setState(() {
                    termAndConditions = !termAndConditions;
                  });
                },
              ),
        button: Button(
          onPressed: () async {
            debugPrint(_emailController.text);
            debugPrint(_passwordController.text);
            try {
              await authProvider.signIn(
                _emailController.text,
                _passwordController.text,
              );
              Navigator.pushReplacementNamed(context, '/home');
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.toString(),
                  ),
                ),
              );
            }
          },
          text: signIn ? 'Sign in' : 'Sign up',
          color: AppColors.primaryColor,
          status: (!signIn && termAndConditions)
              ? Status.enabled
              : (!signIn && !termAndConditions)
                  ? Status.disabled
                  : Status.enabled,
        ),
        suggestion: Suggest(
          login: signIn,
          onTap: () {
            setState(() {
              signIn = !signIn;
            });
          },
        ),
      ),
    );
  }
}
