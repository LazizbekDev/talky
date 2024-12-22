// ignore_for_file: always use package imports
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_en.dart';
import 'localizations_ru.dart';
import 'localizations_uz.dart';

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uz'),
    Locale('ru')
  ];

  /// No description provided for @googleSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get googleSignIn;

  /// No description provided for @withEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with Email'**
  String get withEmail;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get signInError;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @signUpSuggest.
  ///
  /// In en, this message translates to:
  /// **'Don\'t you have an account'**
  String get signUpSuggest;

  /// No description provided for @signInSuggest.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signInSuggest;

  /// No description provided for @showSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up here'**
  String get showSignUp;

  /// No description provided for @showSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in here'**
  String get showSignIn;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @chatError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get chatError;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noData;

  /// No description provided for @noUsers.
  ///
  /// In en, this message translates to:
  /// **'No users available'**
  String get noUsers;

  /// No description provided for @noMessage.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessage;

  /// No description provided for @defaultNick.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultNick;

  /// No description provided for @errorLoadingStatus.
  ///
  /// In en, this message translates to:
  /// **'Error loading status'**
  String get errorLoadingStatus;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Start a new group chat'**
  String get createGroup;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile Not Found'**
  String get profileNotFound;

  /// No description provided for @userProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'User profile not found'**
  String get userProfileNotFound;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get lastSeen;

  /// No description provided for @addNickWarning.
  ///
  /// In en, this message translates to:
  /// **'Please enter your nickname.'**
  String get addNickWarning;

  /// No description provided for @addNick.
  ///
  /// In en, this message translates to:
  /// **'Enter your name or nick'**
  String get addNick;

  /// No description provided for @addBio.
  ///
  /// In en, this message translates to:
  /// **'Enter a bio'**
  String get addBio;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @enterOTP.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4 digit codes we send to you'**
  String get enterOTP;

  /// No description provided for @agreeText.
  ///
  /// In en, this message translates to:
  /// **'I agree to the {terms}'**
  String agreeText(Object terms);

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'terms & conditions'**
  String get terms;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return L10nEn();
    case 'ru': return L10nRu();
    case 'uz': return L10nUz();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
