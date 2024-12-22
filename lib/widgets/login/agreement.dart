import 'package:flutter/material.dart';
import 'package:talky/localization/localization.dart';

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
    final locale = context.locale;
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
        ),
        GestureDetector(
          onTap: onTermsPressed,
          child: Text.rich(
            TextSpan(
              text: locale.agreeText(locale.terms),
              // children: [
              //   TextSpan(
              //     text: locale.terms,
              //     style: const TextStyle(
              //       decoration: TextDecoration.underline,
              //     ),
              //   ),
              // ],
            ),
          ),
        ),
      ],
    );
  }
}
