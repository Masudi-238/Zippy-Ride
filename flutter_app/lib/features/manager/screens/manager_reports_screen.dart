import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';

/// Manager reporting and commission screen matching Manager report code.html.
class ManagerReportsScreen extends StatefulWidget {
  const ManagerReportsScreen({super.key});
  @override State<ManagerReportsScreen> createState() => _ManagerReportsScreenState();
}

class _ManagerReportsScreenState extends State<ManagerReportsScreen> {
  int _navIndex = 2;
  int _tabIndex = 0;
  final _tabs = ['Daily', 'Weekly', 'Monthly'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(children: [
        // Header
        SafeArea(bottom: false, child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.arrow_back_ios, size: 20))),
          const Text('Reporting & Commission', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
          const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.ios_share, size: 20)),
        ]))),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Segmented tabs
          Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: AppColors.slate200.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)), child: Row(children: List.generate(3, (i) {
            final active = _tabIndex == i;
            return Expanded(child: GestureDetector(onTap: () => setState(() => _tabIndex = i), child: Container(padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: active ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: active ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)] : null), child: Text(_tabs[i], textAlign: TextAlign.center, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: active ? FontWeight.w700 : FontWeight.w600, color: active ? AppColors.textPrimary : AppColors.slate500)))));
          }))),
          const SizedBox(height: 16),
          // Metric cards (horizontal scroll)
          SizedBox(height: 110, child: ListView(scrollDirection: Axis.horizontal, children: [
            _MetricCard(label: "TODAY'S REVENUE", value: '\$4,250.00', change: '+12.5%', isPositive: true),
            const SizedBox(width: 12),
            _MetricCard(label: 'ACTIVE DRIVERS', value: '124', change: '+4%', isPositive: true),
            const SizedBox(width: 12),
            _MetricCard(label: 'COMMISSION', value: '\$637.50', change: '-2%', isPositive: false),
          ])),
          const SizedBox(height: 32),
          // Commission settings
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Commission Settings', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w700)), Text('Manage Rates', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary))]),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)), child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Standard Commission', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700)), const Text('Apply to all standard rides', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500))]), Container(width: 48, height: 24, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)), alignment: Alignment.centerRight, padding: const EdgeInsets.all(2), child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)))]),
            const SizedBox(height: 24),
            Row(children: [Expanded(child: _RateInput(label: 'ECONOMY RATE', value: '15')), const SizedBox(width: 16), Expanded(child: _RateInput(label: 'PREMIUM RATE', value: '22'))]),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.only(top: 20), decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))), child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [const Icon(Icons.bolt, color: Colors.orange, size: 20), const SizedBox(width: 8), const Text('Peak Pricing Boost', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700))]), Container(width: 48, height: 24, decoration: BoxDecoration(color: AppColors.slate200, borderRadius: BorderRadius.circular(12)), alignment: Alignment.centerLeft, padding: const EdgeInsets.all(2), child: Container(width: 20, height: 20, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)))]),
              const SizedBox(height: 12),
              const Text('Automated peak detection is currently active for downtown areas.', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500)),
              const SizedBox(height: 16),
              Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withValues(alpha: 0.3))), child: const Text('Save Changes', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700))),
            ])),
          ])),
          const SizedBox(height: 32),
          // Daily breakdown
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Daily Breakdown', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w700)), Text('View All', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary))]),
          const SizedBox(height: 16),
          _BreakdownRow(date: 'Oct 24, 2023', rides: '142 Rides', revenue: '\$2,450.00', commission: 'Comm: \$367.50'),
          const SizedBox(height: 12),
          _BreakdownRow(date: 'Oct 23, 2023', rides: '128 Rides', revenue: '\$1,980.50', commission: 'Comm: \$297.08'),
          const SizedBox(height: 12),
          _BreakdownRow(date: 'Oct 22, 2023', rides: '165 Rides', revenue: '\$3,120.00', commission: 'Comm: \$468.00'),
          const SizedBox(height: 32),
          Center(child: Text('LAST UPDATED: TODAY, 09:41 AM', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 2.0, color: AppColors.slate400))),
        ]))),
      ]),
      bottomNavigationBar: ZippyBottomNavBar(currentIndex: _navIndex, items: const [NavItem(icon: Icons.home_outlined, label: 'Home'), NavItem(icon: Icons.directions_car_outlined, label: 'Drivers'), NavItem(icon: Icons.bar_chart, label: 'Reports'), NavItem(icon: Icons.payments_outlined, label: 'Payouts'), NavItem(icon: Icons.settings_outlined, label: 'Settings')], onTap: (i) { setState(() => _navIndex = i); if (i == 3) Navigator.of(context).pushNamed('/manager-payout'); }),
    );
  }
}

class _MetricCard extends StatelessWidget { final String label; final String value; final String change; final bool isPositive; const _MetricCard({required this.label, required this.value, required this.change, required this.isPositive}); @override Widget build(BuildContext context) => Container(width: 160, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1.0, color: AppColors.slate500)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Row(children: [Icon(isPositive ? Icons.trending_up : Icons.trending_down, size: 14, color: isPositive ? AppColors.primary : AppColors.error), const SizedBox(width: 4), Text(change, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: isPositive ? AppColors.primary : AppColors.error))])])); }
class _RateInput extends StatelessWidget { final String label; final String value; const _RateInput({required this.label, required this.value}); @override Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: AppColors.slate500)), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: AppColors.slate50, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderMedium)), child: Row(children: [Text(value, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700)), const Spacer(), const Text('%', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.slate400))]))]); }
class _BreakdownRow extends StatelessWidget { final String date; final String rides; final String revenue; final String commission; const _BreakdownRow({required this.date, required this.rides, required this.revenue, required this.commission}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.slate50, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.calendar_today, color: AppColors.primary, size: 18)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(date, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)), Text(rides, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500))])), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(revenue, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)), Text(commission, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary))])])); }
