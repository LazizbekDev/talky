// ignore_for_file: always use package imports

import 'localizations.dart';

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get googleSignIn => 'Sign in with Google';

  @override
  String get withEmail => 'Continue with Email';

  @override
  String get signInError => 'Sign-in failed. Please try again.';

  @override
  String get or => 'OR';

  @override
  String get signUpSuggest => 'Don\'t you have an account';

  @override
  String get signInSuggest => 'Already have an account?';

  @override
  String get showSignUp => 'Sign up here';

  @override
  String get showSignIn => 'Sign in here';
}
