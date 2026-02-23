import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/zippy_app_bar.dart';

/// Driver verification screen matching Driver document verification code.html.
/// Features: progress bar (2/4 verified), document checklist with status
/// indicators (verified/pending/action required), disabled submit button.
class DriverVerificationScreen extends StatelessWidget {
  const DriverVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            color: Colors.white.withValues(alpha: 0.8),
            child: const ZippyAppBar(title: 'Verification'),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('Getting Started', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              const Text('Complete these steps to start driving.', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, color: AppColors.slate500)),
                            ]),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              const Text('2/4', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.primary)),
                              const Text('VERIFIED', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.0, color: AppColors.slate400)),
                            ]),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: const LinearProgressIndicator(
                            value: 0.5,
                            minHeight: 10,
                            backgroundColor: AppColors.slate200,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text('REQUIRED DOCUMENTS', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.slate400)),
                  ),
                  const SizedBox(height: 16),

                  // Document items
                  _DocumentItem(
                    icon: Icons.badge_outlined,
                    title: "Driver's License",
                    subtitle: 'Verified on Oct 24',
                    status: _DocStatus.verified,
                  ),
                  const SizedBox(height: 16),
                  _DocumentItem(
                    icon: Icons.shield_outlined,
                    title: 'Vehicle Insurance',
                    subtitle: 'Verified on Oct 25',
                    status: _DocStatus.verified,
                  ),
                  const SizedBox(height: 16),
                  _DocumentItem(
                    icon: Icons.person_search_outlined,
                    title: 'Background Check',
                    subtitle: 'Pending review',
                    status: _DocStatus.pending,
                  ),
                  const SizedBox(height: 16),
                  _DocumentItem(
                    icon: Icons.car_crash_outlined,
                    title: 'Vehicle Registration',
                    subtitle: 'ACTION REQUIRED',
                    status: _DocStatus.actionRequired,
                  ),

                  const SizedBox(height: 40),
                  // Help section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.slate50.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'Need help with your documents?\n',
                          style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500, height: 1.5),
                          children: [
                            TextSpan(
                              text: 'Contact Driver Support',
                              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Sticky bottom CTA
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          border: const Border(top: BorderSide(color: AppColors.borderLight)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.slate200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Submit Application',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.slate400),
            ),
          ),
        ),
      ),
    );
  }
}

enum _DocStatus { verified, pending, actionRequired }

class _DocumentItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final _DocStatus status;

  const _DocumentItem({required this.icon, required this.title, required this.subtitle, required this.status});

  @override
  Widget build(BuildContext context) {
    Color iconBg, iconColor, subtitleColor;
    Widget trailing;

    switch (status) {
      case _DocStatus.verified:
        iconBg = AppColors.primaryLight;
        iconColor = AppColors.primary;
        subtitleColor = AppColors.primary;
        trailing = Container(
          width: 24, height: 24,
          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 14),
        );
      case _DocStatus.pending:
        iconBg = const Color(0xFFFEF3C7); // amber-100
        iconColor = AppColors.warning;
        subtitleColor = AppColors.warning;
        trailing = const Icon(Icons.chevron_right, color: AppColors.slate300);
      case _DocStatus.actionRequired:
        iconBg = const Color(0xFFFFE4E6); // rose-100
        iconColor = AppColors.error;
        subtitleColor = AppColors.error;
        trailing = Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.slate400),
        ]);
    }

    final isAction = status == _DocStatus.actionRequired;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status == _DocStatus.verified ? AppColors.slate50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAction ? const Color(0xFFFFE4E6) : AppColors.borderLight,
          width: isAction ? 2 : 1,
        ),
        boxShadow: status != _DocStatus.verified
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 12, offset: const Offset(0, 4))]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: isAction ? FontWeight.w700 : FontWeight.w500, color: subtitleColor)),
          ])),
          trailing,
        ],
      ),
    );
  }
}
