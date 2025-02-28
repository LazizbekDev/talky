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

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get chatError => 'Error';

  @override
  String get noData => 'No data found';

  @override
  String get noUsers => 'No users available';

  @override
  String get noMessage => 'No messages yet';

  @override
  String get defaultNick => 'User';

  @override
  String get errorLoadingStatus => 'Error loading status';

  @override
  String get cancel => 'Cancel';

  @override
  String get done => 'Done';

  @override
  String get search => 'Search';

  @override
  String get group => 'Group';

  @override
  String get back => 'Back';

  @override
  String get online => 'Online';

  @override
  String get createGroup => 'Start a new group chat';

  @override
  String get profileNotFound => 'Profile Not Found';

  @override
  String get userProfileNotFound => 'User profile not found';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get logOut => 'Log out';

  @override
  String get lastSeen => 'Last seen';

  @override
  String get addNickWarning => 'Please enter your nickname.';

  @override
  String get addNick => 'Enter your name or nick';

  @override
  String get addBio => 'Enter a bio';

  @override
  String get complete => 'Complete';

  @override
  String get enterOTP => 'Enter the 4 digit codes we send to you';

  @override
  String agreeText(Object terms) {
    return 'I agree to the $terms';
  }

  @override
  String get terms => 'terms & conditions';
}
