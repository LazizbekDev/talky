import 'package:talky/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          width: 24,
          margin: const EdgeInsets.only(left: 18),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE5F1FF),
          ),
          child: IconButton(
            icon: Image.asset(
              'assets/images/pop.png',
              width: 14,
            ),
            onPressed: () {},
          ),
        ),
        title: Row(
          children: [
            Text(
              'Talky',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).signOut().then(
                (_) {
                  Navigator.pushReplacementNamed(
                    context,
                    RouteNames.splash,
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: const Center(
        child: Text("HOME"),
      ),
    );
  }
}
