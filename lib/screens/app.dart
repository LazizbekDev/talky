import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talky/providers/auth_provider.dart';
import 'package:talky/routes/app_routes.dart';
import 'package:talky/routes/route_names.dart';
import 'package:talky/utilities/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'TALKY',
        theme: appTheme(),
        initialRoute: RouteNames.splash,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
