import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/zippy_button.dart';
import '../../../widgets/bottom_nav_bar.dart';

/// Manager analytics and payout screen matching manager activity and payout code.html.
class ManagerPayoutScreen extends StatefulWidget {
  const ManagerPayoutScreen({super.key});
  @override State<ManagerPayoutScreen> createState() => _ManagerPayoutScreenState();
}

class _ManagerPayoutScreenState extends State<ManagerPayoutScreen> {
  int _navIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(children: [
        SafeArea(bottom: false, child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: Row(children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back_ios, size: 20))),
          const SizedBox(width: 8),
          const Text('Analytics & Payouts', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
          const Spacer(),
          Stack(children: [const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.notifications_outlined, size: 24)), Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)))]),
        ]))),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), child: Column(children: [
          // Summary cards
          Row(children: [
            Expanded(child: _SummaryCard(label: 'TOTAL REVENUE', value: '\$42,850.20', change: '+12.5%', isRevenue: true)),
            const SizedBox(width: 16),
            Expanded(child: _SummaryCard(label: 'COMMISSION', value: '\$6,427.50', change: '+10.2%', isRevenue: false)),
          ]),
          const SizedBox(height: 24),
          // Payout card
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.slate900, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 16)]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Available for Payout', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.slate400)), const SizedBox(height: 4), const Text('\$4,120.00', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white))]), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), shape: BoxShape.circle), child: const Icon(Icons.account_balance_wallet, color: AppColors.primary, size: 28))]),
            const SizedBox(height: 20),
            ZippyButton(text: 'Request Payout', leadingIcon: Icons.payments, onPressed: () {}),
            const SizedBox(height: 16),
            Center(child: Text('STANDARD PROCESSING: 1-3 BUSINESS DAYS', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: AppColors.slate500))),
          ])),
          const SizedBox(height: 32),
          // Revenue trends
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Revenue Trends', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3)), Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(8)), child: Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]), child: const Text('30D', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700))), Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), child: Text('90D', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate500)))]))]),
          const SizedBox(height: 16),
          Container(height: 192, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderMedium)), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [const Spacer(), Container(height: 2, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(1))), const SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Oct 01', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate500)), Text('Oct 15', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate500)), Text('Today', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate500))])])),
          const SizedBox(height: 32),
          // Fleet performance
          Align(alignment: Alignment.centerLeft, child: const Text('Fleet Performance', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -0.3))),
          const SizedBox(height: 16),
          _FleetGroup(icon: Icons.electric_car, color: Colors.blue, name: 'Premium Fleet', drivers: '12 Active Drivers', revenue: '\$18,420', rate: '15% Cut'),
          const SizedBox(height: 12),
          _FleetGroup(icon: Icons.nightlight, color: Colors.orange, name: 'Night Shift', drivers: '24 Active Drivers', revenue: '\$14,210', rate: '12% Cut'),
          const SizedBox(height: 12),
          _FleetGroup(icon: Icons.airport_shuttle, color: Colors.purple, name: 'Airport Transit', drivers: '8 Active Drivers', revenue: '\$10,220', rate: '18% Cut'),
        ]))),
      ]),
      bottomNavigationBar: ZippyBottomNavBar(currentIndex: _navIndex, items: const [NavItem(icon: Icons.home_outlined, label: 'Home'), NavItem(icon: Icons.analytics_outlined, label: 'Analytics'), NavItem(icon: Icons.group_outlined, label: 'Fleet'), NavItem(icon: Icons.person_outline, label: 'Profile')], onTap: (i) => setState(() => _navIndex = i)),
    );
  }
}

class _SummaryCard extends StatelessWidget { final String label; final String value; final String change; final bool isRevenue; const _SummaryCard({required this.label, required this.value, required this.change, required this.isRevenue}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: isRevenue ? AppColors.primary.withValues(alpha: 0.05) : AppColors.slate100, borderRadius: BorderRadius.circular(12), border: Border.all(color: isRevenue ? AppColors.primary.withValues(alpha: 0.2) : AppColors.borderMedium)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.0, color: isRevenue ? AppColors.primary : AppColors.slate500)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Row(children: [const Icon(Icons.trending_up, size: 12, color: AppColors.primary), const SizedBox(width: 4), Text(change, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary))])])); }
class _FleetGroup extends StatelessWidget { final IconData icon; final Color color; final String name; final String drivers; final String revenue; final String rate; const _FleetGroup({required this.icon, required this.color, required this.name, required this.drivers, required this.revenue, required this.rate}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderMedium)), child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 22)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)), Text(drivers, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500))])), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(revenue, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w900)), Text(rate, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary))])])); }
