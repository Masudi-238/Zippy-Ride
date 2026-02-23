import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';
import '../providers/rider_provider.dart';

/// Rider dashboard screen matching Rider dashboard2code.html.
/// Features: map background, wallet widget, search bar,
/// favorite places, promotional carousel, bottom nav.
class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});

  @override
  State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final rider = context.watch<RiderProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map Background (placeholder with gradient)
          Positioned.fill(
            child: Container(
              color: AppColors.slate200,
              child: Stack(
                children: [
                  // Simulated map with subtle pattern
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.slate200,
                          AppColors.slate100,
                        ],
                      ),
                    ),
                  ),
                  // Map placeholder text
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 48,
                          color: AppColors.slate400.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mapbox Map',
                          style: TextStyle(
                            color: AppColors.slate400.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // User location dot
                  Center(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Car markers
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.25,
                    left: MediaQuery.of(context).size.width * 0.2,
                    child: const Icon(Icons.directions_car,
                        size: 28, color: AppColors.slate800),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.45,
                    right: MediaQuery.of(context).size.width * 0.2,
                    child: const Icon(Icons.directions_car,
                        size: 28, color: AppColors.slate800),
                  ),
                ],
              ),
            ),
          ),

          // Top header overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      // App logo
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.electric_car,
                          color: AppColors.backgroundDark,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Zippy Ride',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      // Notification bell
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          size: 20,
                          color: AppColors.slate700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // FABs on right side
          Positioned(
            right: 16,
            bottom: MediaQuery.of(context).size.height * 0.45,
            child: Column(
              children: [
                _MapFAB(icon: Icons.my_location, onTap: () {}),
                const SizedBox(height: 8),
                _MapFAB(icon: Icons.add, onTap: () {}),
                const SizedBox(height: 8),
                _MapFAB(icon: Icons.remove, onTap: () {}),
              ],
            ),
          ),

          // Bottom sheet overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _DashboardBottomSheet(
              walletBalance: rider.walletBalance,
              onSearch: () {
                Navigator.of(context).pushNamed('/ride-selection');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: ZippyBottomNavBar(
        currentIndex: _navIndex,
        items: ZippyBottomNavBar.riderItems,
        onTap: (index) {
          setState(() => _navIndex = index);
          if (index == 1) {
            Navigator.of(context).pushNamed('/ride-history');
          } else if (index == 2) {
            Navigator.of(context).pushNamed('/wallet');
          }
        },
      ),
    );
  }
}

/// Map floating action button.
class _MapFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MapFAB({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.slate700),
      ),
    );
  }
}

/// Dashboard bottom sheet content.
class _DashboardBottomSheet extends StatelessWidget {
  final double walletBalance;
  final VoidCallback onSearch;

  const _DashboardBottomSheet({
    required this.walletBalance,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, -8),
          ),
        ],
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 48,
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.slate200,
              borderRadius: BorderRadius.circular(3),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Smart Wallet Widget
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet,
                          color: AppColors.backgroundDark,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'SMART BALANCE',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.0,
                                color: AppColors.slate500,
                              ),
                            ),
                            Text(
                              '\$${walletBalance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Add Funds',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.backgroundDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Search bar
                GestureDetector(
                  onTap: onSearch,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderMedium),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search,
                            color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Where to?',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.slate400,
                            ),
                          ),
                        ),
                        Container(
                          height: 24,
                          width: 1,
                          color: AppColors.slate300,
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.schedule,
                            color: AppColors.slate400, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Favorite Places
                const Text(
                  'FAVORITE PLACES',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 88,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FavPlaceItem(icon: Icons.home, label: 'Home'),
                      const SizedBox(width: 16),
                      _FavPlaceItem(icon: Icons.work, label: 'Work'),
                      const SizedBox(width: 16),
                      _FavPlaceItem(
                          icon: Icons.fitness_center, label: 'Gym'),
                      const SizedBox(width: 16),
                      _FavPlaceItem(
                          icon: Icons.add, label: 'Add New', isDashed: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Offers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'OFFERS FOR YOU',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppColors.slate500,
                      ),
                    ),
                    Text(
                      'View all',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 144,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    children: [
                      _PromoCard(
                        promoCode: 'ZIP50',
                        title: '50% Off your next\n3 Eco-Rides',
                        ctaText: 'Claim Offer',
                        gradientColors: [Colors.black87, Colors.transparent],
                      ),
                      const SizedBox(width: 16),
                      _PromoCard(
                        promoCode: 'Referral',
                        title: 'Earn \$10 for every\nfriend referred',
                        ctaText: 'Invite Now',
                        gradientColors: [
                          AppColors.primary.withValues(alpha: 0.9),
                          Colors.transparent,
                        ],
                        isDark: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Favorite place button item.
class _FavPlaceItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDashed;

  const _FavPlaceItem({
    required this.icon,
    required this.label,
    this.isDashed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDashed ? Colors.transparent : AppColors.slate100,
            borderRadius: BorderRadius.circular(16),
            border: isDashed
                ? Border.all(
                    color: AppColors.borderMedium,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  )
                : null,
          ),
          child: Icon(
            icon,
            color: isDashed ? AppColors.slate400 : AppColors.slate600,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDashed ? AppColors.slate500 : AppColors.slate700,
          ),
        ),
      ],
    );
  }
}

/// Promotional card in the carousel.
class _PromoCard extends StatelessWidget {
  final String promoCode;
  final String title;
  final String ctaText;
  final List<Color> gradientColors;
  final bool isDark;

  const _PromoCard({
    required this.promoCode,
    required this.title,
    required this.ctaText,
    required this.gradientColors,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.slate900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: gradientColors,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Promo Code: $promoCode',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.primary : AppColors.backgroundDark,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.backgroundDark,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.2)
                        : AppColors.backgroundDark,
                    borderRadius: BorderRadius.circular(8),
                    border: isDark
                        ? Border.all(
                            color: Colors.white.withValues(alpha: 0.3))
                        : null,
                  ),
                  child: Text(
                    ctaText,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
