// ignore_for_file: always use package imports

import 'localizations.dart';

/// The translations for Russian (`ru`).
class L10nRu extends L10n {
  L10nRu([String locale = 'ru']) : super(locale);

  @override
  String get googleSignIn => 'Войти через Google';

  @override
  String get withEmail => 'Продолжить с электронной почтой';

  @override
  String get signInError => 'Ошибка входа. Пожалуйста, попробуйте еще раз.';

  @override
  String get or => 'ИЛИ';

  @override
  String get signUpSuggest => 'У вас нет аккаунта?';

  @override
  String get signInSuggest => 'Уже есть аккаунт?';

  @override
  String get showSignUp => 'Зарегистрируйтесь здесь';

  @override
  String get showSignIn => 'Войти здесь';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get chatError => 'Ошибка';

  @override
  String get noData => 'Данные не найдены';

  @override
  String get noUsers => 'Пользователи отсутствуют';

  @override
  String get noMessage => 'Пока нет сообщений';

  @override
  String get defaultNick => 'Пользователь';

  @override
  String get errorLoadingStatus => 'Ошибка загрузки статуса';

  @override
  String get cancel => 'Отмена';

  @override
  String get done => 'Готово';

  @override
  String get search => 'Поиск';

  @override
  String get group => 'Группа';

  @override
  String get back => 'Назад';

  @override
  String get online => 'В сети';

  @override
  String get createGroup => 'Создайте новый групповой чат';

  @override
  String get profileNotFound => 'Профиль не найден';

  @override
  String get userProfileNotFound => 'Профиль пользователя не найден';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get logOut => 'Выйти';

  @override
  String get lastSeen => 'Был в сети';

  @override
  String get addNickWarning => 'Пожалуйста, введите свой никнейм.';

  @override
  String get addNick => 'Введите свое имя или никнейм';

  @override
  String get addBio => 'Введите биографию';

  @override
  String get complete => 'Завершить';

  @override
  String get enterOTP => 'Введите 4-значный код, который мы вам отправили';

  @override
  String agreeText(Object terms) {
    return 'Я согласен с $terms';
  }

  @override
  String get terms => 'условиями и положениями';
}
