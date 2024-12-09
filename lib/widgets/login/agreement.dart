import 'package:flutter/material.dart';

class Agreement extends StatelessWidget {
  const Agreement({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.onTermsPressed,
  });
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTermsPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
        ),
        GestureDetector(
          onTap: onTermsPressed,
          child: const Text.rich(
            TextSpan(
              text: 'I agree to the ',
              children: [
                TextSpan(
                  text: 'terms & conditions',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
