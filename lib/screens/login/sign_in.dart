// ignore_for_file: use_build_context_synchronously

import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:talky/localization/localization.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/layouts/login_layout.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/utilities/status.dart';
import 'package:talky/widgets/login/agreement.dart';
import 'package:talky/widgets/button.dart';
import 'package:talky/widgets/forgot_password.dart';
import 'package:talky/widgets/input.dart';
import 'package:talky/widgets/login/suggest.dart';

// ignore: must_be_immutable
class SignIn extends StatefulWidget {
  SignIn({super.key, this.signIn = true});
  bool signIn;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final textInter = GoogleFonts.inter();
    final locale = context.locale;

    void signIn() async {
      final localContext = context;

      try {
        await authProvider.signIn(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        Navigator.pushReplacementNamed(localContext, RouteNames.chat);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(localContext).showSnackBar(
          SnackBar(
            content: Text(
              e.toString(),
            ),
          ),
        );
      }
    }

    void verify() {
      EmailOTP.sendOTP(email: _emailController.text);
      Navigator.pushNamed(
        context,
        '/verify',
        arguments: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
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
      body: LoginLayout(
        caption: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "${widget.signIn ? locale.signIn : locale.signUp} ${locale.withEmail}",
            style: textInter.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        email: Input(
          obscureText: false,
          controller: _emailController,
          hintText: 'Email',
        ),
        password: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Input(
            controller: _passwordController,
            obscureText: _obscureText,
            hintText: 'Enter ${widget.signIn ? 'your' : 'new'} password',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: _togglePasswordVisibility,
            ),
          ),
        ),
        forgotPassword: widget.signIn
            ? ForgotPassword(
                onPressed: () {
                  debugPrint("Forgotten password");
                },
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
          onPressed: () {
            widget.signIn ? signIn() : verify();
          },
          text: widget.signIn ? locale.signIn : locale.signUp,
          color: AppColors.primaryColor,
          status: (!widget.signIn && termAndConditions)
              ? Status.enabled
              : (!widget.signIn && !termAndConditions)
                  ? Status.disabled
                  : Status.enabled,
        ),
        suggestion: Suggest(
          login: widget.signIn,
          onTap: () {
            setState(() {
              widget.signIn = !widget.signIn;
            });
          },
        ),
      ),
    );
  }
}
