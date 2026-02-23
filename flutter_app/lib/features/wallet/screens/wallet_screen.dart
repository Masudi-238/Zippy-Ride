import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/bottom_nav_bar.dart';

/// Smart Wallet screen matching smart wallet management code.html.
/// Features: balance card, quick actions (Top Up/Transfer/Withdraw),
/// transaction history list, bottom nav.
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _navIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.backgroundLight.withValues(alpha: 0.8),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
                        child: const Icon(Icons.arrow_back_ios_new, size: 16),
                      ),
                    ),
                    const Text('Smart Wallet', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
                      child: const Icon(Icons.help_outline, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.slate900,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))],
                    ),
                    child: Stack(
                      children: [
                        Positioned(top: -40, right: -40, child: Container(width: 100, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.2)))),
                        Positioned(bottom: -30, left: -30, child: Container(width: 80, height: 80, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary.withValues(alpha: 0.1)))),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text('TOTAL BALANCE', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 1.0, color: Colors.white.withValues(alpha: 0.8))),
                              const SizedBox(width: 8),
                              Icon(Icons.info_outline, size: 12, color: Colors.white.withValues(alpha: 0.6)),
                            ]),
                            const SizedBox(height: 8),
                            Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
                              const Text('\$1,240', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5)),
                              Text('.50', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
                            ]),
                            const SizedBox(height: 32),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              // Avatar stack
                              Row(children: [
                                Container(width: 32, height: 32, decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.slate700, border: Border.all(color: AppColors.slate900, width: 2)), child: const Icon(Icons.person, size: 16, color: Colors.white)),
                                Container(width: 32, height: 32, margin: const EdgeInsets.only(left: -8), decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.primary, border: Border.all(color: AppColors.slate900, width: 2)), child: const Center(child: Text('+3', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.textOnPrimary)))),
                              ]),
                              // Active card badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary.withValues(alpha: 0.3))),
                                child: Row(children: [
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  const Text('Active Card', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                ]),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _QuickAction(icon: Icons.add_circle, label: 'Top Up', isPrimary: true, onTap: () {}),
                      _QuickAction(icon: Icons.send, label: 'Transfer', onTap: () {}),
                      _QuickAction(icon: Icons.account_balance_wallet, label: 'Withdraw', onTap: () {}),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Transaction history
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Recent Activity', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                    Row(children: [
                      Text('See All', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                      const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
                    ]),
                  ]),
                  const SizedBox(height: 20),

                  _TransactionItem(icon: Icons.directions_car, iconBg: AppColors.slate100, iconColor: AppColors.slate600, title: 'Ride Payment #ZR-882', subtitle: 'Today, 2:45 PM', amount: '-\$12.40', amountColor: AppColors.textPrimary, type: 'DEBIT'),
                  const SizedBox(height: 16),
                  _TransactionItem(icon: Icons.account_balance, iconBg: AppColors.primary.withValues(alpha: 0.1), iconColor: AppColors.primary, title: 'Top Up from Bank', subtitle: 'Yesterday, 10:15 AM', amount: '+\$500.00', amountColor: AppColors.primary, type: 'CREDIT'),
                  const SizedBox(height: 16),
                  _TransactionItem(icon: Icons.card_giftcard, iconBg: const Color(0xFFFEF3C7), iconColor: AppColors.warning, title: 'Weekly Bonus Reward', subtitle: 'Mar 22, 6:00 PM', amount: '+\$25.00', amountColor: AppColors.warning, type: 'REWARD'),
                  const SizedBox(height: 16),
                  Opacity(
                    opacity: 0.7,
                    child: _TransactionItem(icon: Icons.directions_car, iconBg: AppColors.slate100, iconColor: AppColors.slate600, title: 'Ride Payment #ZR-712', subtitle: 'Mar 21, 11:30 AM', amount: '-\$18.25', amountColor: AppColors.textPrimary, type: 'DEBIT'),
                  ),

                  const SizedBox(height: 32),
                  // Security footer
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.lock, size: 14, color: AppColors.slate400),
                    const SizedBox(width: 8),
                    const Text('Transactions are encrypted and secure', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.slate400)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ZippyBottomNavBar(
        currentIndex: _navIndex,
        items: const [
          NavItem(icon: Icons.home_outlined, label: 'Home'),
          NavItem(icon: Icons.directions_car_outlined, label: 'Rides'),
          NavItem(icon: Icons.account_balance_wallet, label: 'Wallet'),
          NavItem(icon: Icons.notifications_outlined, label: 'Activity'),
          NavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, this.isPrimary = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isPrimary ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))] : [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4)],
            border: isPrimary ? null : Border.all(color: AppColors.borderMedium),
          ),
          child: Icon(icon, color: isPrimary ? AppColors.textOnPrimary : AppColors.textPrimary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate600)),
      ]),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final String type;
  const _TransactionItem({required this.icon, required this.iconBg, required this.iconColor, required this.title, required this.subtitle, required this.amount, required this.amountColor, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.borderLight)),
      child: Row(children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: iconColor, size: 22)),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)),
          Text(subtitle, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.slate500)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(amount, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700, color: amountColor)),
          Text(type, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: amountColor.withValues(alpha: 0.7))),
        ]),
      ]),
    );
  }
}
