import 'package:flutter/material.dart';
import 'package:azaktilza/widgets/offline_screen.dart';
import 'package:azaktilza/widgets/RestartWidget.dart';
import 'package:azaktilza/widgets/splash_screen.dart';

class RefreshWrapper extends StatelessWidget {
  final bool isOnline;
  final bool seenOnboarding;

  const RefreshWrapper({
    super.key,
    required this.isOnline,
    required this.seenOnboarding,
  });

  Future<void> _handleRefresh(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    RestartWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _handleRefresh(context),
      child: isOnline
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SplashScreen(seenOnboarding: seenOnboarding),
                ),
              ],
            )
          : const OfflineScreen(),
    );
  }
}
