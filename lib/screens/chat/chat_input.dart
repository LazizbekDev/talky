import 'package:flutter/material.dart';

class ChatInputField extends StatefulWidget {
  final Function() sendMessage;
  const ChatInputField({super.key, required this.sendMessage});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _iconAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isExpanded)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                mini: true,
                onPressed: () {
                },
                child: const Icon(Icons.attach_file),
              ),
              FloatingActionButton(
                mini: true,
                onPressed: () {
                },
                child: const Icon(Icons.camera_alt),
              ),
              FloatingActionButton(
                mini: true,
                onPressed: () {
                },
                child: const Icon(Icons.mic),
              ),
            ],
          ),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Message",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: toggleExpansion,
              child: RotationTransition(
                turns: _iconAnimation,
                child: Icon(isExpanded ? Icons.close : Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
