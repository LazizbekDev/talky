import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:talky/utilities/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBox extends StatelessWidget {
  final bool sender;
  final String message;
  final DateTime timestamp;
  final List<String>? imageUrls;
  final String fileUrl;

  const MessageBox({
    super.key,
    required this.sender,
    required this.message,
    required this.timestamp,
    this.imageUrls,
    required this.fileUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (imageUrls != null && imageUrls!.isNotEmpty)
          GestureDetector(
            onTap: () => _showImage(context, imageUrls!,
                title: DateFormat('hh:mm a').format(timestamp)),
            child: Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrls![0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        if (message.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: sender ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: sender ? Colors.white : Colors.black,
              ),
            ),
          ),
        if (fileUrl.isNotEmpty)
          GestureDetector(
            onTap: () => _openFile(fileUrl),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: sender ? AppColors.primaryColor : AppColors.middleGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/file.png',
                    color: Colors.white,
                    height: 14,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    Uri.parse(fileUrl).pathSegments.last.split('chatFiles/')[1],
                    style: TextStyle(
                      color: sender
                          ? AppColors.backgroundColor
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            DateFormat('hh:mm a').format(timestamp),
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  void _showImage(BuildContext context, List<String> imageUrls, {title}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black54,
            title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Future<void> _openFile(String url) async {
    final Uri fileUri = Uri.parse(url);

    if (await launchUrl(fileUri)) {
      debugPrint("Could not open the file.");
    }
  }
}
