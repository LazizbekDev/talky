import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talky/localization/generated/localizations.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/providers/chat_provider.dart';
import 'package:talky/providers/user_provider.dart';
import 'package:talky/providers/localization_provider.dart';
import 'package:talky/routes/app_routes.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/services/auth/firebase_auth_service.dart';
import 'package:talky/services/auth/firestore_service.dart';
import 'package:talky/services/chat/chat_service.dart';
import 'package:talky/services/storage_service.dart';
import 'package:talky/utilities/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    EmailOTP.config(
      appName: 'Talky',
      otpType: OTPType.numeric,
      expiry: 60000 * 5,
      emailTheme: EmailTheme.v6,
      appEmail: 'dev.talky@gmail.com',
      otpLength: 4,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            FirebaseAuthService(),
            FirestoreService(),
            StorageService(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(
            ChatService(
              StorageService(),
            ),
            StorageService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LocalizationProvider(),
        ),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (
          context,
          localizationProvider,
          _,
        ) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'TALKY',
            theme: appTheme(),
            localizationsDelegates: L10n.localizationsDelegates,
            supportedLocales: L10n.supportedLocales,
            initialRoute: RouteNames.splash,
            locale: localizationProvider.locale,
            onGenerateRoute: generateRoute,
          );
        },
      ),
    );
  }
}
