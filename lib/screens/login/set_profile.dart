import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:talky/localization/localization.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/utilities/status.dart';
import 'package:talky/widgets/button.dart';
import 'package:talky/widgets/input.dart';
import 'package:talky/widgets/login/user_image_picker.dart';

class SetProfile extends StatefulWidget {
  const SetProfile({super.key});

  @override
  State<SetProfile> createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  final nickNameController = TextEditingController();
  final bioController = TextEditingController();
  File? selectedImage;
  final textStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryColor,
  );

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context, listen: true);
    final currentImage = selectedImage;
    final locale = context.locale;

    void complete(context) async {
      if (currentImage == null) {
        debugPrint('No image selected');
      } else if (nickNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(locale.addNickWarning)),
        );
      } else {
        debugPrint('Image selected: ${currentImage.path}');
        File imageFile = File(currentImage.path);
        await userProvider.uploadUserInfoToFirestore(
          selectedImage: imageFile,
          nick: nickNameController.text,
          description: bioController.text,
        );

        Navigator.pushNamed(context, RouteNames.chat);
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
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
            onPressed: () {
              debugPrint("chat input setProfile");
            },
          ),
        ),
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            locale.back,
            style: textStyle,
          ),
          Expanded(
            child: Center(
              child: Text(
                'Profile',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 70),
        ]),
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
                        hintText: locale.addNick,
                      ),
                      const SizedBox(height: 18),
                      Input(
                        obscureText: false,
                        controller: bioController,
                        hintText: locale.addBio,
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Button(
                          onPressed: () => complete(context),
                          text: locale.complete,
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
