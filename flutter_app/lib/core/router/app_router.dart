import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zippy_ride/features/auth/presentation/pages/login_page.dart';
import 'package:zippy_ride/features/auth/presentation/pages/register_page.dart';
import 'package:zippy_ride/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:zippy_ride/features/rider/presentation/pages/rider_home_page.dart';
import 'package:zippy_ride/features/driver/presentation/pages/driver_home_page.dart';
import 'package:zippy_ride/features/auth/domain/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!isLoggedIn && !isAuthRoute && !isOnboarding) {
        return '/auth/login';
      }

      if (isLoggedIn && (isAuthRoute || isOnboarding)) {
        // Redirect based on role
        switch (authState.user?.role) {
          case 'driver':
            return '/driver';
          case 'manager':
          case 'super_admin':
            return '/admin';
          default:
            return '/rider';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterPage(),
      ),
      // Rider routes
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/rider',
            builder: (context, state) => const RiderHomePage(),
            routes: [
              GoRoute(
                path: 'book',
                builder: (context, state) => const Placeholder(child: Text('Book Ride')),
              ),
              GoRoute(
                path: 'history',
                builder: (context, state) => const Placeholder(child: Text('Ride History')),
              ),
              GoRoute(
                path: 'wallet',
                builder: (context, state) => const Placeholder(child: Text('Wallet')),
              ),
            ],
          ),
        ],
      ),
      // Driver routes
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/driver',
            builder: (context, state) => const DriverHomePage(),
            routes: [
              GoRoute(
                path: 'earnings',
                builder: (context, state) => const Placeholder(child: Text('Earnings')),
              ),
              GoRoute(
                path: 'documents',
                builder: (context, state) => const Placeholder(child: Text('Documents')),
              ),
            ],
          ),
        ],
      ),
      // Admin routes
      GoRoute(
        path: '/admin',
        builder: (context, state) => const Placeholder(child: Text('Admin Dashboard')),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
});

class Placeholder extends StatelessWidget {
  final Widget child;
  const Placeholder({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: child));
}
