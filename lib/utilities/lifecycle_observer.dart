import 'package:flutter/widgets.dart';
import 'package:talky/providers/user_provider.dart';

class LifecycleObserver extends WidgetsBindingObserver {
  LifecycleObserver(this.userProvider);
  final UserProvider userProvider;

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
