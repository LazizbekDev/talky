import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class SendData extends StatelessWidget {
  const SendData({
    super.key,
    required this.sendToChat,
    required this.chooseImage,
    required this.chooseFile,
    required this.controller,
  });
  final Function({String? text, String? imageUrl}) sendToChat;
  final VoidCallback chooseImage;
  final VoidCallback chooseFile;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SizedBox(
              height: 54,
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Message',
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.lightGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primaryColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.lightGray),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: const ImageIcon(
                      AssetImage('assets/images/send.png'),
                      size: 20,
                    ),
                    color: AppColors.lightGray,
                    onPressed: () {
                      final text = controller.text.trim();
                      if (text.isNotEmpty) {
                        sendToChat(text: text);
                        controller.clear();
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SpeedDial(
            icon: Icons.add,
            activeIcon: Icons.close,
            buttonSize: const Size(56.0, 56.0),
            backgroundColor: AppColors.primaryColor,
            overlayOpacity: 0,
            childPadding: const EdgeInsets.all(0),
            spaceBetweenChildren: 20,
            children: [
              SpeedDialChild(
                child: const Icon(
                  Icons.mic,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                onTap: () => debugPrint('Microphone tapped'),
              ),
              SpeedDialChild(
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primaryColor,
                  size: 24,
                ),
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                onTap: chooseImage,
              ),
              SpeedDialChild(
                child: const ImageIcon(
                  AssetImage('assets/images/file.png'),
                  size: 20,
                  color: AppColors.primaryColor,
                ),
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                onTap: chooseFile,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
