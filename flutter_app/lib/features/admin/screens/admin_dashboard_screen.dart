import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';

/// Super admin control panel matching superadmin controll panale code.html.
/// Features: metric cards (riders, drivers, revenue, trips), AI surge control,
/// critical alerts feed, bottom nav.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});
  @override State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(children: [
        // Header
        SafeArea(bottom: false, child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: Row(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2), color: AppColors.slate200), child: const Icon(Icons.person, size: 20, color: AppColors.slate600)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Zippy Ride', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate500)), const Text('Super Admin', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700))])),
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.slate100, shape: BoxShape.circle), child: const Icon(Icons.search, size: 22, color: AppColors.slate700)),
          const SizedBox(width: 8),
          Stack(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.slate100, shape: BoxShape.circle), child: const Icon(Icons.notifications_outlined, size: 22, color: AppColors.slate700)), Positioned(top: 8, right: 8, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: AppColors.error, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))))]),
        ]))),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 4, 16, 100), child: Column(children: [
          // Quick metrics
          GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.6, children: [
            _AdminMetric(icon: Icons.groups, label: 'Total Riders', value: '124.5k', change: '+12%', isPositive: true),
            _AdminMetric(icon: Icons.local_taxi, label: 'Active Drivers', value: '8,230', change: '+5%', isPositive: true),
            _AdminMetric(icon: Icons.payments, label: 'Daily Revenue', value: '\$42.8k', change: '-2%', isPositive: false),
            _AdminMetric(icon: Icons.route, label: 'Total Trips', value: '15.2k', change: '+8%', isPositive: true),
          ]),
          const SizedBox(height: 24),
          // AI Surge Control
          Row(children: [const Icon(Icons.psychology, color: AppColors.primary, size: 22), const SizedBox(width: 8), const Text('AI Surge Control', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700)), const Spacer(), Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)), const SizedBox(width: 4), Text('Live', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.primary))])]),
          const SizedBox(height: 12),
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)]), child: Column(children: [
            Container(height: 160, decoration: BoxDecoration(color: AppColors.slate200, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))), child: Stack(children: [
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [AppColors.slate900.withValues(alpha: 0.8), Colors.transparent]))),
              Positioned(bottom: 16, left: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Downtown Core', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.8))), const Text('Dynamic Surge: 1.5x', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white))])),
              Positioned(top: 16, right: 16, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)), child: const Text('Update AI', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textOnPrimary)))),
            ])),
            Padding(padding: const EdgeInsets.all(16), child: Row(children: [Expanded(child: Text('Demand is high in Downtown. AI recalibration successful.', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, color: AppColors.slate600))), const SizedBox(width: 16), Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.map, color: AppColors.primary, size: 20))])),
          ])),
          const SizedBox(height: 24),
          // Critical alerts
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Critical Alerts', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700)), Text('View All', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary))]),
          const SizedBox(height: 12),
          _AlertItem(color: AppColors.error, icon: Icons.warning, title: 'Server Latency: East Zone', message: 'Response times increased by 250ms in Brooklyn sector.', timeAgo: '2m ago'),
          const SizedBox(height: 12),
          _AlertItem(color: AppColors.warning, icon: Icons.shield, title: 'Suspicious Activity', message: 'Multi-account login attempt detected from IP: 192.168.1.1', timeAgo: '14m ago'),
          const SizedBox(height: 12),
          _AlertItem(color: AppColors.primary, icon: Icons.check_circle, title: 'Payouts Completed', message: 'Weekly driver payouts have been successfully processed.', timeAgo: '45m ago'),
        ]))),
      ]),
      bottomNavigationBar: ZippyBottomNavBar(currentIndex: _navIndex, items: const [NavItem(icon: Icons.dashboard, label: 'Dashboard'), NavItem(icon: Icons.directions_car_outlined, label: 'Operations'), NavItem(icon: Icons.group_outlined, label: 'Users'), NavItem(icon: Icons.settings_outlined, label: 'Settings')], onTap: (i) { setState(() => _navIndex = i); if (i == 2) Navigator.of(context).pushNamed('/admin-verification'); }),
    );
  }
}

class _AdminMetric extends StatelessWidget { final IconData icon; final String label; final String value; final String change; final bool isPositive; const _AdminMetric({required this.icon, required this.label, required this.value, required this.change, required this.isPositive}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Icon(icon, color: AppColors.primary, size: 22), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: (isPositive ? AppColors.primary : AppColors.error).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)), child: Text(change, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: isPositive ? AppColors.primary : AppColors.error)))]), const Spacer(), Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500)), Text(value, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w700))])); }
class _AlertItem extends StatelessWidget { final Color color; final IconData icon; final String title; final String message; final String timeAgo; const _AlertItem({required this.color, required this.icon, required this.title, required this.message, required this.timeAgo}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border(left: BorderSide(color: color, width: 4)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)]), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)), Text(timeAgo, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, color: AppColors.slate400))]), const SizedBox(height: 4), Text(message, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500))]))])); }
