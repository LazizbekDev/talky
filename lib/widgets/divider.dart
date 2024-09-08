import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 30,
        ),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
