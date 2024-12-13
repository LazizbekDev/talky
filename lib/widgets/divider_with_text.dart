import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            indent: 30,
            color: Colors.grey,
            thickness: 1,
            endIndent: 8,
          ),
        ),
        Text(
          'OR',
          style: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
        const Expanded(
          child: Divider(
            indent: 8,
            endIndent: 30,
            color: Colors.grey,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
