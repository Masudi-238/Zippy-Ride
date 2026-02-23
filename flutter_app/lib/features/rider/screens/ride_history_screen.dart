import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';

/// Ride history screen matching Rider History code.html.
/// Features: tabs (All/Completed/Cancelled), ride cards with map thumbnails,
/// route details, rate/rebook actions.
class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  int _selectedTab = 0;
  int _navIndex = 1;

  final List<_RideHistoryItem> _rides = [
    _RideHistoryItem(status: 'Completed', date: 'Oct 24, 2023 \u2022 02:30 PM', price: '\$14.50', pickup: 'Terminal 2, SFO Airport', dropoff: '123 Maple St, San Francisco', rideType: 'Zippy Basic', rating: null, isCancelled: false),
    _RideHistoryItem(status: 'Completed', date: 'Oct 21, 2023 \u2022 08:15 AM', price: '\$32.00', pickup: '88 Market St, Financial District', dropoff: 'Ocean Beach, Great Hwy', rideType: 'Zippy XL', rating: 4, isCancelled: false),
    _RideHistoryItem(status: 'Cancelled', date: 'Oct 19, 2023 \u2022 11:45 PM', price: '\$0.00', pickup: 'The Fillmore, Geary Blvd', dropoff: 'Home', rideType: null, rating: null, isCancelled: true),
  ];

  List<_RideHistoryItem> get _filteredRides {
    if (_selectedTab == 0) return _rides;
    if (_selectedTab == 1) return _rides.where((r) => !r.isCancelled).toList();
    return _rides.where((r) => r.isCancelled).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.backgroundLight,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ride History', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.search, color: AppColors.primary, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Tabs
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: AppColors.slate200.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: List.generate(3, (i) {
                          final labels = ['All', 'Completed', 'Cancelled'];
                          final isActive = _selectedTab == i;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedTab = i),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: isActive ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null,
                                ),
                                child: Text(labels[i], textAlign: TextAlign.center, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: isActive ? FontWeight.w700 : FontWeight.w600, color: isActive ? AppColors.textPrimary : AppColors.slate500)),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Ride cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: _filteredRides.length,
              itemBuilder: (context, index) => _RideCard(ride: _filteredRides[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ZippyBottomNavBar(
        currentIndex: _navIndex,
        items: const [
          NavItem(icon: Icons.home_outlined, label: 'Home'),
          NavItem(icon: Icons.history, label: 'History'),
          NavItem(icon: Icons.account_balance_wallet_outlined, label: 'Wallet'),
          NavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 0) Navigator.of(context).pushReplacementNamed('/rider-dashboard');
        },
      ),
    );
  }
}

class _RideHistoryItem {
  final String status;
  final String date;
  final String price;
  final String pickup;
  final String dropoff;
  final String? rideType;
  final int? rating;
  final bool isCancelled;

  const _RideHistoryItem({required this.status, required this.date, required this.price, required this.pickup, required this.dropoff, this.rideType, this.rating, required this.isCancelled});
}

class _RideCard extends StatelessWidget {
  final _RideHistoryItem ride;
  const _RideCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    final isCancel = ride.isCancelled;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Opacity(
        opacity: isCancel ? 0.8 : 1.0,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: isCancel ? AppColors.error.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.2)),
                      child: Icon(isCancel ? Icons.cancel : Icons.check_circle, size: 18, color: isCancel ? AppColors.error : AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(ride.status.toUpperCase(), style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: isCancel ? AppColors.error : AppColors.primary)),
                      Text(ride.date, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w700)),
                    ]),
                  ]),
                  Text(ride.price, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w800, color: isCancel ? AppColors.slate400 : AppColors.textPrimary)),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            // Route
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Map thumbnail placeholder
                  Container(
                    width: 96, height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.slate100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.map, color: AppColors.slate300, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.trip_origin, size: 14, color: AppColors.slate400),
                          const SizedBox(width: 8),
                          Expanded(child: Text(ride.pickup, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ]),
                        Container(width: 1, height: 8, margin: const EdgeInsets.only(left: 6), color: AppColors.slate300),
                        Row(children: [
                          Icon(Icons.location_on, size: 14, color: isCancel ? AppColors.slate400 : AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(child: Text(ride.dropoff, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w500, color: isCancel ? AppColors.slate400 : AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        ]),
                        if (ride.rideType != null) ...[
                          const SizedBox(height: 8),
                          Row(children: [
                            Icon(Icons.directions_car, size: 14, color: AppColors.slate400),
                            const SizedBox(width: 4),
                            Text(ride.rideType!, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500)),
                          ]),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Actions
            if (!isCancel)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    if (ride.rating == null)
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.star, size: 18, color: AppColors.textOnPrimary),
                            SizedBox(width: 4),
                            Text('Rate Ride', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textOnPrimary)),
                          ]),
                        ),
                      )
                    else
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) => Icon(Icons.star, size: 20, color: i < ride.rating! ? AppColors.primary : AppColors.slate300))),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(8)),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.replay, size: 18, color: AppColors.slate700),
                          SizedBox(width: 4),
                          Text('Rebook', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.slate700)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
