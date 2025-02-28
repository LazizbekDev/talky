// ignore_for_file: always use package imports

import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class L10nUz extends L10n {
  L10nUz([String locale = 'uz']) : super(locale);

  @override
  String get googleSignIn => 'Google orqali tizimga kiring';

  @override
  String get withEmail => 'Elektron pochta orqali davom eting';

  @override
  String get signInError => 'Tizimga kirishda xatolik. Iltimos, qayta urinib ko\'ring.';

  @override
  String get or => 'YOKI';

  @override
  String get signUpSuggest => 'Hisobingiz yo\'qmi?';

  @override
  String get signInSuggest => 'Allaqachon hisobingiz bormi?';

  @override
  String get showSignUp => 'Bu yerda ro\'yxatdan o\'ting';

  @override
  String get showSignIn => 'Bu yerda tizimga kiring';

  @override
  String get signIn => 'Tizimga kirish';

  @override
  String get signUp => 'Ro\'yxatdan o\'tish';

  @override
  String get chatError => 'Xatolik';

  @override
  String get noData => 'Ma\'lumot topilmadi';

  @override
  String get noUsers => 'Foydalanuvchilar mavjud emas';

  @override
  String get noMessage => 'Hozircha xabar yo\'q';

  @override
  String get defaultNick => 'Foydalanuvchi';

  @override
  String get errorLoadingStatus => 'Holatni yuklashda xatolik yuz berdi';

  @override
  String get cancel => 'Bekor qilish';

  @override
  String get done => 'Tayyor';

  @override
  String get search => 'Qidiruv';

  @override
  String get group => 'Guruh';

  @override
  String get back => 'Orqaga';

  @override
  String get online => 'Onlayn';

  @override
  String get createGroup => 'Yangi guruh suhbatini boshlang';

  @override
  String get profileNotFound => 'Profil topilmadi';

  @override
  String get userProfileNotFound => 'Foydalanuvchi profili topilmadi';

  @override
  String get editProfile => 'Profilni tahrirlash';

  @override
  String get logOut => 'Tizimdan chiqish';

  @override
  String get lastSeen => 'Oxirgi ko\'rilgan';

  @override
  String get addNickWarning => 'Iltimos, taxallusingizni kiriting.';

  @override
  String get addNick => 'Ismingiz yoki taxallusingizni kiriting';

  @override
  String get addBio => 'Biografiyani kiriting';

  @override
  String get complete => 'Tugatish';

  @override
  String get enterOTP => 'Biz yuborgan 4 raqamli kodni kiriting';

  @override
  String agreeText(Object terms) {
    return 'Men $terms bilan roziman';
  }

  @override
  String get terms => 'shartlar va qoidalar';
}
