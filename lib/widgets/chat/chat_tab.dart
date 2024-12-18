import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:talky/widgets/chat/image_grid.dart';

class ChatTab extends StatelessWidget {
  const ChatTab({super.key, required this.images});
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.inter(
      color: AppColors.lightGray,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: AppColors.primaryColor,
            dividerColor: AppColors.middleGray,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.lightGray,
            tabs: [
              Tab(text: 'Chat'),
              Tab(text: 'Files'),
            ],
          ),
          SizedBox(
            height: 300.0,
            child: TabBarView(
              children: [
                Center(
                  child: Text(
                    "No chat found!",
                    style: textStyle,
                  ),
                ),
                if (images.isNotEmpty)
                  ImageGrid(imagePaths: images)
                else
                  Center(
                    child: Text(
                      "No Files found!",
                      style: textStyle,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
