import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Driver incoming ride request screen matching Driver incomming request code.html.
/// Features: full-screen map, countdown timer with ring, fare info,
/// trip metrics, route details, accept/decline buttons.
class DriverIncomingRequestScreen extends StatefulWidget {
  const DriverIncomingRequestScreen({super.key});

  @override
  State<DriverIncomingRequestScreen> createState() => _DriverIncomingRequestScreenState();
}

class _DriverIncomingRequestScreenState extends State<DriverIncomingRequestScreen> {
  int _secondsRemaining = 22;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        if (mounted) Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _secondsRemaining / 22.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Stack(
        children: [
          // Map background
          Positioned.fill(
            child: Container(
              color: AppColors.slate300,
              child: Center(child: Icon(Icons.map, size: 80, color: AppColors.slate400.withValues(alpha: 0.5))),
            ),
          ),

          // Top status overlay
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black.withValues(alpha: 0.2), Colors.transparent])),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12)]),
                        child: Row(children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          const Text('ONLINE', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12)]),
                        child: const Icon(Icons.person, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Central timer
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0, right: 0,
            child: Column(
              children: [
                SizedBox(
                  width: 192, height: 192,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow
                      Container(
                        width: 192, height: 192,
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 10)]),
                      ),
                      // Progress ring
                      SizedBox(
                        width: 192, height: 192,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          backgroundColor: Colors.white.withValues(alpha: 0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        ),
                      ),
                      // Inner circle
                      Container(
                        width: 160, height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 24)],
                          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$_secondsRemaining', style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 48, fontWeight: FontWeight.w800)),
                            const Text('SECONDS', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.slate500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(color: AppColors.backgroundDark.withValues(alpha: 0.8), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withValues(alpha: 0.1))),
                  child: const Text('New Request: Premier Ride', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                ),
              ],
            ),
          ),

          // FABs
          Positioned(
            bottom: 440, right: 24,
            child: Column(children: [
              _FloatingBtn(icon: Icons.layers, onTap: () {}),
              const SizedBox(height: 12),
              _FloatingBtn(icon: Icons.my_location, onTap: () {}, isPrimary: true),
            ]),
          ),

          // Bottom trip sheet
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 40, offset: const Offset(0, -10))],
                border: Border(top: BorderSide(color: AppColors.borderLight)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 48, height: 6, decoration: BoxDecoration(color: AppColors.slate200, borderRadius: BorderRadius.circular(3))),
                      const SizedBox(height: 24),
                      // Fare info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Text('ESTIMATED EARNINGS', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary, letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            const Text('\$18.45', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                          ]),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                              child: const Row(children: [Icon(Icons.bolt, size: 12, color: AppColors.primary), SizedBox(width: 2), Text('1.5x SURGE', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary))]),
                            ),
                            const SizedBox(height: 8),
                            const Text('Incl. Tips & Tolls', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate500)),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Trip metrics
                      Row(children: [
                        Expanded(child: _TripMetric(icon: Icons.near_me, label: 'PICKUP', value: '4 min (1.2 mi)')),
                        const SizedBox(width: 16),
                        Expanded(child: _TripMetric(icon: Icons.schedule, label: 'TRIP', value: '15 min (8.2 mi)')),
                      ]),
                      const SizedBox(height: 24),
                      // Route details
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Column(children: [
                          Container(width: 12, height: 12, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2), color: Colors.white)),
                          Container(width: 1, height: 32, decoration: const BoxDecoration(border: Border(left: BorderSide(color: AppColors.slate300, width: 2, style: BorderStyle.solid)))),
                          Container(width: 12, height: 12, decoration: BoxDecoration(color: AppColors.slate800, borderRadius: BorderRadius.circular(2))),
                        ]),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('PICKUP FROM', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.slate500)),
                          const Text('The Ferry Building, Embarcadero', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 20),
                          const Text('DROP OFF TO', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.slate500)),
                          const Text('Mission District, 24th St', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)),
                        ])),
                      ]),
                      const SizedBox(height: 24),
                      // Action buttons
                      Row(children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(border: Border.all(color: AppColors.borderMedium, width: 2), borderRadius: BorderRadius.circular(16)),
                              child: const Center(child: Text('Decline', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.slate600))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () { Navigator.of(context).pop(); },
                            child: Container(
                              height: 64,
                              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4))]),
                              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Text('Accept Request', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textOnPrimary)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward, color: AppColors.textOnPrimary, size: 22),
                              ]),
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;
  const _FloatingBtn({required this.icon, required this.onTap, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16)]),
        child: Icon(icon, size: 22, color: isPrimary ? AppColors.primary : AppColors.slate800),
      ),
    );
  }
}

class _TripMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _TripMetric({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: AppColors.slate500)),
          Text(value, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w700)),
        ])),
      ]),
    );
  }
}
