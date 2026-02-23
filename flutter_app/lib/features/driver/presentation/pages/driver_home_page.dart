import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zippy_ride/core/theme/app_theme.dart';
import 'package:zippy_ride/features/auth/domain/providers/auth_provider.dart';

class DriverHomePage extends ConsumerStatefulWidget {
  const DriverHomePage({super.key});

  @override
  ConsumerState<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends ConsumerState<DriverHomePage> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, ${user?.firstName ?? "Driver"}'),
        actions: [
          // Online/Offline toggle
          Switch.adaptive(
            value: _isOnline,
            onChanged: (value) => setState(() => _isOnline = value),
            activeColor: AppColors.success,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Status banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: _isOnline ? AppColors.success : AppColors.textSecondary,
            child: Text(
              _isOnline ? 'You are Online - Waiting for ride requests' : 'You are Offline - Go online to receive requests',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),

          // Map placeholder
          Expanded(
            child: Container(
              color: AppColors.background,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 80, color: AppColors.primary),
                    SizedBox(height: 16),
                    Text('Driver Map View', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ),
          ),

          // Earnings summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
            ),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Today's Earnings", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('\$0.00', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(label: 'Trips', value: '0'),
                    _StatItem(label: 'Hours', value: '0.0'),
                    _StatItem(label: 'Rating', value: '5.0'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Documents'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ],
    );
  }
}
