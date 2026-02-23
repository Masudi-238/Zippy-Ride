import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/registration_screen.dart';
import 'features/driver/providers/driver_provider.dart';
import 'features/driver/screens/driver_earnings_screen.dart';
import 'features/driver/screens/driver_incoming_request_screen.dart';
import 'features/driver/screens/driver_verification_screen.dart';
import 'features/onboarding/screens/onboarding_screen.dart';
import 'features/rider/providers/rider_provider.dart';
import 'features/rider/screens/ride_history_screen.dart';
import 'features/rider/screens/ride_selection_screen.dart';
import 'features/rider/screens/rider_dashboard_screen.dart';
import 'features/wallet/providers/wallet_provider.dart';
import 'features/wallet/screens/wallet_screen.dart';
import 'services/api/api_client.dart';
import 'services/auth/auth_service.dart';
import 'services/auth/token_storage.dart';

/// Root application widget for Zippy Ride.
/// Sets up dependency injection via Provider and routing.
class ZippyRideApp extends StatelessWidget {
  const ZippyRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create service instances
    final tokenStorage = TokenStorage();
    final apiClient = ApiClient(tokenStorage: tokenStorage);
    final authService = AuthService(
      apiClient: apiClient,
      tokenStorage: tokenStorage,
    );

    return MultiProvider(
      providers: [
        // Auth
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService: authService),
        ),
        // Rider
        ChangeNotifierProvider(
          create: (_) => RiderProvider(apiClient: apiClient),
        ),
        // Driver
        ChangeNotifierProvider(
          create: (_) => DriverProvider(apiClient: apiClient),
        ),
        // Wallet
        ChangeNotifierProvider(
          create: (_) => WalletProvider(apiClient: apiClient),
        ),
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

  /// Named route generator for the application.
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/onboarding':
        return _buildRoute(const OnboardingScreen(), settings);
      case '/login':
        return _buildRoute(const LoginScreen(), settings);
      case '/register':
        return _buildRoute(const RegistrationScreen(), settings);
      case '/rider-dashboard':
        return _buildRoute(const RiderDashboardScreen(), settings);
      case '/ride-selection':
        return _buildRoute(const RideSelectionScreen(), settings);
      case '/ride-history':
        return _buildRoute(const RideHistoryScreen(), settings);
      case '/driver-earnings':
        return _buildRoute(const DriverEarningsScreen(), settings);
      case '/driver-incoming-request':
        return _buildRoute(const DriverIncomingRequestScreen(), settings);
      case '/driver-verification':
        return _buildRoute(const DriverVerificationScreen(), settings);
      case '/wallet':
        return _buildRoute(const WalletScreen(), settings);
      default:
        return _buildRoute(const OnboardingScreen(), settings);
    }
  }

  /// Creates a MaterialPageRoute with the given widget and settings.
  MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
