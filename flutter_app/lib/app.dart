import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/admin/providers/admin_provider.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/admin/screens/admin_verification_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/registration_screen.dart';
import 'features/driver/providers/driver_provider.dart';
import 'features/driver/screens/driver_earnings_screen.dart';
import 'features/driver/screens/driver_incoming_request_screen.dart';
import 'features/driver/screens/driver_verification_screen.dart';
import 'features/manager/providers/manager_provider.dart';
import 'features/manager/screens/manager_fleet_screen.dart';
import 'features/manager/screens/manager_payout_screen.dart';
import 'features/manager/screens/manager_reports_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/rider/providers/rider_provider.dart';
import 'features/rider/screens/ride_history_screen.dart';
import 'features/rider/screens/ride_selection_screen.dart';
import 'features/rider/screens/rider_dashboard_screen.dart';
import 'features/wallet/providers/wallet_provider.dart';
import 'features/wallet/screens/wallet_screen.dart';
import 'models/user.dart';
import 'services/api/api_client.dart';
import 'services/auth/auth_service.dart';
import 'services/auth/token_storage.dart';

/// Root application widget for Zippy Ride.
/// Sets up dependency injection via Provider and routing for all 4 user roles:
/// rider, driver, manager, admin.
class ZippyRideApp extends StatelessWidget {
  const ZippyRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage: tokenStorage);
    final authService = AuthService(apiClient: apiClient, tokenStorage: tokenStorage);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authService: authService)),
        ChangeNotifierProvider(create: (_) => RiderProvider(apiClient: apiClient)),
        ChangeNotifierProvider(create: (_) => DriverProvider(apiClient: apiClient)),
        ChangeNotifierProvider(create: (_) => WalletProvider(apiClient: apiClient)),
        ChangeNotifierProvider(create: (_) => ManagerProvider(apiClient: apiClient)),
        ChangeNotifierProvider(create: (_) => AdminProvider(apiClient: apiClient)),
      ],
      child: MaterialApp(
        title: 'Zippy Ride',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        initialRoute: '/onboarding',
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      // Onboarding & Auth
      '/onboarding': (_) => const OnboardingScreen(),
      '/login': (_) => const LoginScreen(),
      '/register': (_) => const RegistrationScreen(),
      // Rider
      '/rider-dashboard': (_) => const RiderDashboardScreen(),
      '/ride-selection': (_) => const RideSelectionScreen(),
      '/ride-history': (_) => const RideHistoryScreen(),
      // Driver
      '/driver-earnings': (_) => const DriverEarningsScreen(),
      '/driver-incoming-request': (_) => const DriverIncomingRequestScreen(),
      '/driver-verification': (_) => const DriverVerificationScreen(),
      // Manager
      '/manager-fleet': (_) => const ManagerFleetScreen(),
      '/manager-reports': (_) => const ManagerReportsScreen(),
      '/manager-payout': (_) => const ManagerPayoutScreen(),
      // Super Admin
      '/admin-dashboard': (_) => const AdminDashboardScreen(),
      '/admin-verification': (_) => const AdminVerificationScreen(),
      // Wallet (shared across roles)
      '/wallet': (_) => const WalletScreen(),
    };

    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(builder: builder, settings: settings);
    }
    return MaterialPageRoute(builder: (_) => const OnboardingScreen(), settings: settings);
  }

  /// Determines the initial dashboard route based on user role.
  static String getDashboardRoute(UserRole role) {
    switch (role) {
      case UserRole.rider:
        return '/rider-dashboard';
      case UserRole.driver:
        return '/driver-earnings';
      case UserRole.manager:
        return '/manager-fleet';
      case UserRole.admin:
        return '/admin-dashboard';
    }
  }
}
