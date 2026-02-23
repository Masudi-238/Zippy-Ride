import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';

/// Manager fleet dashboard matching Manager fleet dashaod code.html.
/// Features: map with driver markers/clusters, quick filters (All/Online/Busy/Idle),
/// floating analytics panel with stats and recent trip activity.
class ManagerFleetScreen extends StatefulWidget {
  const ManagerFleetScreen({super.key});
  @override
  State<ManagerFleetScreen> createState() => _ManagerFleetScreenState();
}

class _ManagerFleetScreenState extends State<ManagerFleetScreen> {
  int _navIndex = 0;
  int _filterIndex = 0;
  final _filters = ['All Drivers', 'Online (124)', 'Busy (48)', 'Idle (12)'];
  final _filterIcons = [Icons.local_taxi, Icons.circle, Icons.warning_amber, Icons.timer];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Map background
          Positioned.fill(child: Container(color: AppColors.slate200, child: Center(child: Icon(Icons.map, size: 80, color: AppColors.slate300)))),
          // Map markers
          Positioned(top: MediaQuery.of(context).size.height * 0.3, left: MediaQuery.of(context).size.width * 0.2, child: _DriverMarker(isCluster: false)),
          Positioned(top: MediaQuery.of(context).size.height * 0.25, right: MediaQuery.of(context).size.width * 0.25, child: _DriverMarker(isCluster: true, count: 12)),
          Positioned(bottom: MediaQuery.of(context).size.height * 0.35, right: MediaQuery.of(context).size.width * 0.1, child: _BusyMarker()),
          // Header
          Positioned(top: 0, left: 0, right: 0, child: Container(
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.backgroundLight.withValues(alpha: 0.9), Colors.transparent])),
            child: SafeArea(bottom: false, child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), child: Column(children: [
              Row(children: [
                Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.dashboard, color: AppColors.primary, size: 20)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Fleet Dashboard', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)),
                  Row(children: [Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)), const SizedBox(width: 6), Text('LIVE MONITORING', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 1.0, color: AppColors.slate500))]),
                ])),
                _HeaderBtn(icon: Icons.notifications_outlined),
                const SizedBox(width: 8),
                _HeaderBtn(icon: Icons.account_circle_outlined),
              ]),
              const SizedBox(height: 16),
              SizedBox(height: 36, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _filters.length, itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
                onTap: () => setState(() => _filterIndex = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: _filterIndex == i ? AppColors.primary : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(_filterIcons[i], size: 14, color: _filterIndex == i ? AppColors.textOnPrimary : i == 2 ? AppColors.warning : AppColors.primary), const SizedBox(width: 8), Text(_filters[i], style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: _filterIndex == i ? AppColors.textOnPrimary : AppColors.slate700))]),
                ),
              )))),
            ]))),
          )),
          // Map controls
          Positioned(right: 16, top: MediaQuery.of(context).size.height * 0.4, child: Column(children: [
            _MapControl(icon: Icons.my_location), const SizedBox(height: 8),
            _MapControl(icon: Icons.layers), const SizedBox(height: 8),
            Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12)], border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))), child: Column(children: [SizedBox(width: 48, height: 48, child: Icon(Icons.add, color: AppColors.slate700)), Container(height: 1, width: 48, color: AppColors.primary.withValues(alpha: 0.05)), SizedBox(width: 48, height: 48, child: Icon(Icons.remove, color: AppColors.slate700))])),
          ])),
          // Floating analytics panel
          Positioned(bottom: 80, left: 16, right: 16, child: Container(
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 24)], border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))),
            child: Column(children: [
              Container(margin: const EdgeInsets.only(top: 8), width: 40, height: 4, decoration: BoxDecoration(color: AppColors.slate300, borderRadius: BorderRadius.circular(2))),
              Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                Row(children: [
                  Expanded(child: _StatCard(label: 'ONLINE DRIVERS', value: '124', badge: '+12%', badgeColor: AppColors.primary, bgColor: AppColors.primary.withValues(alpha: 0.05))),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'ACTIVE TRIPS', value: '82', badge: '85% Cap.', badgeColor: AppColors.slate500, bgColor: AppColors.slate100)),
                ]),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Recent Activity', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)), Text('View All', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary))]),
                const SizedBox(height: 12),
                _TripItem(name: 'Alex M.', id: '#ZP-829', route: 'SFO Intl Airport \u2192 Union Square', fare: '\$24.50', status: 'EN ROUTE', statusColor: AppColors.primary, timeAgo: '2 min ago'),
                const SizedBox(height: 8),
                _TripItem(name: 'Sarah K.', id: '#ZP-104', route: 'Mission District \u2192 Pier 39', fare: '\$18.20', status: 'PICKING UP', statusColor: AppColors.warning, timeAgo: 'Just now'),
              ])),
            ]),
          )),
        ],
      ),
      bottomNavigationBar: ZippyBottomNavBar(currentIndex: _navIndex, items: const [NavItem(icon: Icons.map, label: 'Monitor'), NavItem(icon: Icons.group_outlined, label: 'Drivers'), NavItem(icon: Icons.insights, label: 'Analytics'), NavItem(icon: Icons.settings_outlined, label: 'Settings')], onTap: (i) { setState(() => _navIndex = i); if (i == 2) Navigator.of(context).pushNamed('/manager-reports'); }),
    );
  }
}

class _HeaderBtn extends StatelessWidget { final IconData icon; const _HeaderBtn({required this.icon}); @override Widget build(BuildContext context) => Container(width: 40, height: 40, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)], border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))), child: Icon(icon, size: 20, color: AppColors.slate700)); }
class _MapControl extends StatelessWidget { final IconData icon; const _MapControl({required this.icon}); @override Widget build(BuildContext context) => Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12)], border: Border.all(color: AppColors.primary.withValues(alpha: 0.1))), child: Icon(icon, size: 22, color: AppColors.slate700)); }
class _DriverMarker extends StatelessWidget { final bool isCluster; final int count; const _DriverMarker({this.isCluster = false, this.count = 0}); @override Widget build(BuildContext context) => Container(width: isCluster ? 40 : 32, height: isCluster ? 40 : 32, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: isCluster ? 0.9 : 1.0), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8)]), child: Center(child: isCluster ? Text('$count', style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textOnPrimary)) : const Icon(Icons.local_taxi, size: 16, color: AppColors.textOnPrimary))); }
class _BusyMarker extends StatelessWidget { @override Widget build(BuildContext context) => Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.warning, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: AppColors.warning.withValues(alpha: 0.3), blurRadius: 8)]), child: const Icon(Icons.person, size: 16, color: Colors.white)); }
class _StatCard extends StatelessWidget { final String label; final String value; final String badge; final Color badgeColor; final Color bgColor; const _StatCard({required this.label, required this.value, required this.badge, required this.badgeColor, required this.bgColor}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: badgeColor.withValues(alpha: 0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.slate500)), const SizedBox(height: 4), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(value, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 24, fontWeight: FontWeight.w800)), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)), child: Text(badge, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w700, color: badgeColor)))])])); }
class _TripItem extends StatelessWidget { final String name; final String id; final String route; final String fare; final String status; final Color statusColor; final String timeAgo; const _TripItem({required this.name, required this.id, required this.route, required this.fare, required this.status, required this.statusColor, required this.timeAgo}); @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.slate50, borderRadius: BorderRadius.circular(12)), child: Row(children: [Stack(children: [Container(width: 40, height: 40, decoration: const BoxDecoration(color: AppColors.slate200, shape: BoxShape.circle), child: const Icon(Icons.person, size: 20, color: AppColors.slate500)), Positioned(bottom: -2, right: -2, child: Container(width: 16, height: 16, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2))))]), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('$name $id', style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700)), Text(timeAgo, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate400))]), Row(children: [Icon(Icons.navigation, size: 12, color: statusColor), const SizedBox(width: 4), Expanded(child: Text(route, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, color: AppColors.slate500), overflow: TextOverflow.ellipsis))])])), const SizedBox(width: 8), Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text(fare, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w800)), Text(status, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 9, fontWeight: FontWeight.w700, color: statusColor))])])); }
