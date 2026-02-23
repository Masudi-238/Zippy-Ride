import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';

/// Driver earnings dashboard matching Diver Eanr dashboard code.html.
/// Features: weekly earnings summary with bar chart, cash out card,
/// key metrics (online time, trips, rating), recent activity list.
class DriverEarningsScreen extends StatefulWidget {
  const DriverEarningsScreen({super.key});

  @override
  State<DriverEarningsScreen> createState() => _DriverEarningsScreenState();
}

class _DriverEarningsScreenState extends State<DriverEarningsScreen> {
  int _navIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                      child: const Icon(Icons.account_balance_wallet, color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('EARNINGS DASHBOARD', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.0, color: AppColors.slate500)),
                        Text('Zippy Ride Driver', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.borderMedium)),
                      child: const Icon(Icons.notifications_outlined, color: AppColors.slate600, size: 20),
                    ),
                  ],
                ),
              ),

              // Weekly earnings
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('This Week (Mar 4 - 10)', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.slate500)),
                          const Text('\$842.50', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                        ]),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                          child: const Row(children: [
                            Icon(Icons.trending_up, color: AppColors.primary, size: 14),
                            SizedBox(width: 4),
                            Text('+12.5%', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                          ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Bar chart
                    _WeeklyBarChart(),
                  ],
                ),
              ),

              // Cash out card
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("TODAY'S BALANCE", style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textOnPrimary.withValues(alpha: 0.6))),
                          const Text('\$124.80', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textOnPrimary)),
                        ]),
                        Icon(Icons.payments_outlined, size: 30, color: AppColors.textOnPrimary.withValues(alpha: 0.4)),
                      ]),
                      const SizedBox(height: 8),
                      Text('Available for instant cash out to your bank.', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.textOnPrimary.withValues(alpha: 0.7))),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(color: AppColors.slate900, borderRadius: BorderRadius.circular(12)),
                        child: const Text('Cash Out Now', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),

              // Metrics grid
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  children: [
                    Expanded(child: _MetricCard(icon: Icons.schedule, label: 'ONLINE', value: '34h 20m')),
                    const SizedBox(width: 12),
                    Expanded(child: _MetricCard(icon: Icons.directions_car, label: 'TRIPS', value: '142')),
                    const SizedBox(width: 12),
                    Expanded(child: _MetricCard(icon: Icons.star, label: 'RATING', value: '4.95')),
                  ],
                ),
              ),

              // Recent Activity
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Recent Activity', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700)),
                    Text('VIEW ALL', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _ActivityItem(icon: Icons.person_pin_circle, title: 'Downtown to Airport', subtitle: 'Today, 2:45 PM', amount: '+\$24.50'),
              _ActivityItem(icon: Icons.history, title: 'Weekly Bonus Tier 1', subtitle: 'Yesterday, 11:30 PM', amount: '+\$50.00'),
              _ActivityItem(icon: Icons.person_pin_circle, title: 'Uptown Delivery', subtitle: 'Yesterday, 8:15 PM', amount: '+\$12.20', faded: true),

              // Driver status
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2), color: AppColors.slate200),
                        child: const Icon(Icons.person, size: 20, color: AppColors.slate600),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('CURRENT STATUS', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.slate500)),
                        Row(children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                          const SizedBox(width: 6),
                          const Text('Online & Active', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)),
                        ]),
                      ])),
                      const Icon(Icons.chevron_right, color: AppColors.slate400),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ZippyBottomNavBar(
        currentIndex: _navIndex,
        items: ZippyBottomNavBar.driverItems,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  final List<double> values = const [0.30, 0.65, 0.90, 0.45, 0.75, 0.20, 0.15];
  final List<String> labels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20)]),
      child: SizedBox(
        height: 128,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (i) {
            final isHighest = values[i] == values.reduce((a, b) => a > b ? a : b);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: values[i],
                          child: Container(
                            decoration: BoxDecoration(
                              color: isHighest ? AppColors.primary : AppColors.primary.withValues(alpha: 0.4),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(labels[i], style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: isHighest ? AppColors.textPrimary : AppColors.slate400)),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetricCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
      child: Column(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.slate400)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool faded;
  const _ActivityItem({required this.icon, required this.title, required this.subtitle, required this.amount, this.faded = false});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: faded ? 0.6 : 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
          child: Row(
            children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.slate100, shape: BoxShape.circle), child: Icon(icon, color: AppColors.slate600, size: 20)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)),
                Text(subtitle, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500)),
              ])),
              Text(amount, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}
