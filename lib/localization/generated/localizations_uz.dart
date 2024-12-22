// ignore_for_file: always use package imports

import 'localizations.dart';

/// The translations for Uzbek (`uz`).
class L10nUz extends L10n {
  L10nUz([String locale = 'uz']) : super(locale);

  @override
  String get googleSignIn => 'Google orqali kirish';

  @override
  String get withEmail => 'Email bilan davom etish';

  @override
  String get signInError => 'Kirishda xatolik bo\'ldi! Iltimos keyinroq qaytadan xarakat qiling';

  @override
  String get or => 'YOKI';

  @override
  String get signUpSuggest => 'Accountingiz yo\'qmi?';

  @override
  String get signInSuggest => 'Allaqchon accountingiz mavjudmi?';

  @override
  String get showSignUp => 'Yangi account yarating';

  @override
  String get showSignIn => 'Accountingizga kiring';
}
