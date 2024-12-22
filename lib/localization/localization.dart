import 'package:flutter/material.dart';
import 'package:talky/localization/generated/localizations.dart';

extension Localization on BuildContext {
  L10n get locale {
    return L10n.of(this);
  }
}