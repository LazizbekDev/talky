import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/utilities/status.dart';
import 'package:talky/widgets/button.dart';
import 'package:talky/widgets/input.dart';
import 'package:talky/widgets/user_image_picker.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SetProfileState createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  final nickNameController = TextEditingController();
  final bioController = TextEditingController();
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteNames.home);
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF7272DB).withOpacity(0.1),
                    child: Image.asset(
                      "assets/images/pop.png",
                      width: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Back',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'Profile',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                      Center(
                        child: UserImagePicker(
                          onPickImage: (pickedImage) =>
                              selectedImage = pickedImage,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Input(
                        obscureText: false,
                        controller: nickNameController,
                        hintText: 'Enter your name or nick',
                      ),
                      const SizedBox(height: 18),
                      Input(
                        obscureText: false,
                        controller: bioController,
                        hintText: 'Enter a bio',
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Button(
                          onPressed: () async {
                            if (selectedImage == null) {
                              debugPrint('No image selected');
                            } else {
                              debugPrint(
                                  'Image selected: ${selectedImage!.path}');
                              File imageFile = File(selectedImage!.path);
                              await userProvider.uploadUserInfoToFireStore(
                                imageFile,
                              );
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Profile Updated')),
                              );
                            }
                          },
                          text: "Complete",
                          status: userProvider.isUploading
                              ? Status.loading
                              : Status.enabled,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
