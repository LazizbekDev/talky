import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final Widget leftText;
  final Widget title;
  const Navbar({super.key, required this.leftText, this.title = const SizedBox()});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          leftText,
          const Spacer(),
          title,
          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}
