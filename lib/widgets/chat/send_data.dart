import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';

class SendData extends StatelessWidget {
  final Function({String? text, String? imageUrl}) sendToChat;
  final VoidCallback chooseImage;
  final TextEditingController controller;

  const SendData({
    super.key,
    required this.sendToChat,
    required this.chooseImage,
    required this.controller,
  });

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
                    icon: const Icon(Icons.send_rounded),
                    color: AppColors.textPrimary,
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
            backgroundColor: Colors.blue,
            overlayOpacity: 0,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.attach_file, color: Colors.blue),
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                onTap: () => debugPrint('Attach file tapped'),
              ),
              SpeedDialChild(
                child: const Icon(Icons.camera_alt, color: Colors.blue),
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                onTap: chooseImage,
              ),
              SpeedDialChild(
                child: const Icon(Icons.mic, color: Colors.blue),
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                onTap: () => debugPrint('Microphone tapped'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
