import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBox extends StatelessWidget {
  final bool sender;
  final String message;
  final DateTime timestamp;
  final String? imageUrl; // Add this line

  const MessageBox({
    super.key,
    required this.sender,
    required this.message,
    required this.timestamp,
    this.imageUrl, // Accept the imageUrl
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: sender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (imageUrl != null && imageUrl!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Image.network(imageUrl!),
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
}
