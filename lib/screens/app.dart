import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/providers/chat_provider.dart';
import 'package:talky/providers/users_provider.dart';
import 'package:talky/routes/app_routes.dart';
import 'package:talky/routes/route_names.dart';
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TALKY',
        theme: appTheme(),
        initialRoute: RouteNames.splash,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
