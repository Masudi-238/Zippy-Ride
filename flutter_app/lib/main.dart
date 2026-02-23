import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zippy_ride/core/config/app_config.dart';
import 'package:zippy_ride/core/router/app_router.dart';
import 'package:zippy_ride/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfig.initialize(Environment.development);

  runApp(
    const ProviderScope(
      child: ZippyRideApp(),
    ),
  );
}

class ZippyRideApp extends ConsumerWidget {
  const ZippyRideApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Zippy Ride',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
