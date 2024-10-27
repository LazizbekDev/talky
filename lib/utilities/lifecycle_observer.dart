import 'package:flutter/widgets.dart';
import 'package:talky/providers/users_provider.dart';

class LifecycleObserver extends WidgetsBindingObserver {
  final UserProvider userProvider;

  LifecycleObserver(this.userProvider);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      userProvider.updateLastSeenStatus(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      userProvider.updateLastSeenStatus(false);
    }
  }
}
