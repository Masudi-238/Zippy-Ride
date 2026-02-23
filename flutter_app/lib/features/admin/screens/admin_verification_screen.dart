import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// Super admin verification queue screen matching multstop running code.html.
/// Features: priority queue strip with driver avatars, driver profile summary,
/// identity documents, vehicle details, background status, approve/reject buttons.
class AdminVerificationScreen extends StatelessWidget {
  const AdminVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(children: [
        // Header
        SafeArea(bottom: false, child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 12), child: Column(children: [
          Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios, size: 20, color: AppColors.slate500)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Verification Queue', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700)), Text('128 PENDING GLOBALLY', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: AppColors.slate500))])),
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle), child: const Icon(Icons.filter_list, color: AppColors.primary, size: 20)),
          ]),
        ]))),
        // Priority queue strip
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: AppColors.borderMedium))),
          child: SizedBox(height: 70, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [
            _QueueAvatar(isActive: true, label: 'Review'),
            const SizedBox(width: 16), _QueueAvatar(isActive: false),
            const SizedBox(width: 16), _QueueAvatar(isActive: false),
            const SizedBox(width: 16), _QueueAvatar(isActive: false),
            const SizedBox(width: 16),
            Container(width: 56, height: 56, decoration: BoxDecoration(color: AppColors.slate100, shape: BoxShape.circle), child: Center(child: Text('+124', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slate400)))),
          ])),
        ),
        // Main content
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 120), child: Column(children: [
          // Driver profile
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderMedium)), child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(width: 64, height: 64, decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.person, size: 32, color: AppColors.slate400)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Marcus Sterling', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700)), Row(children: [const Icon(Icons.location_on, size: 14, color: AppColors.slate500), const SizedBox(width: 4), const Text('Berlin, Germany', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 12, color: AppColors.slate500))]), const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(4)), child: const Text('FLAGGED: LOW RES ID', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFB45309))))])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('APPLICATION ID', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate400)), const Text('#ZP-8829-BS', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w500))]),
            ]),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.only(top: 16), decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))), child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('PHONE', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate400)), const Text('+49 152 4920 182', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14))])),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('JOIN DATE', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.slate400)), const Text('Oct 24, 2023', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14))])),
            ])),
          ])),
          const SizedBox(height: 24),
          // Identity documents
          _SectionHeader(title: 'IDENTITY DOCUMENTS', badge: '2 Files'),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: _DocThumb(label: 'License Front')), const SizedBox(width: 12), Expanded(child: _DocThumb(label: 'License Back'))]),
          const SizedBox(height: 24),
          // Vehicle
          _SectionHeader(title: 'VEHICLE VERIFICATION', badge: 'Tesla Model 3', badgeColor: Colors.blue),
          const SizedBox(height: 12),
          Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderMedium)), child: Column(children: [
            Container(height: 160, decoration: BoxDecoration(color: AppColors.slate200, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))), child: Stack(children: [Center(child: Icon(Icons.directions_car, size: 60, color: AppColors.slate400)), Positioned(bottom: 8, right: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(4)), child: const Text('Plate: B-ZY-2023', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))))])),
            Padding(padding: const EdgeInsets.all(12), child: Row(children: [_VehicleThumb(), const SizedBox(width: 8), _VehicleThumb(), const SizedBox(width: 8), Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.slate50, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderMedium, width: 2, strokeAlign: BorderSide.strokeAlignInside)), child: Icon(Icons.add_photo_alternate, color: AppColors.slate300, size: 28))])),
          ])),
          const SizedBox(height: 24),
          // Background status
          _SectionHeader(title: 'BACKGROUND STATUS'),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderMedium)), child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [const Icon(Icons.verified_user, color: AppColors.primary, size: 20), const SizedBox(width: 8), const Text('Criminal Record Check', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w500))]), const Text('CLEARED', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primary))]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(Icons.history, color: AppColors.warning, size: 20), const SizedBox(width: 8), const Text('Driving Offense History', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w500))]), Text('1 MINOR (2019)', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.warning))]),
          ])),
          const SizedBox(height: 24),
          // Notes
          _SectionHeader(title: 'INTERNAL NOTES'),
          const SizedBox(height: 12),
          TextField(maxLines: 3, decoration: InputDecoration(hintText: 'Add a note for the next reviewer...', hintStyle: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, color: AppColors.slate400), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderMedium)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderMedium)))),
        ]))),
      ]),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), border: const Border(top: BorderSide(color: AppColors.borderMedium))),
        child: Row(children: [
          Expanded(child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(12)), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.close, color: AppColors.error, size: 20), const SizedBox(width: 8), const Text('Reject', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700))])))),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: GestureDetector(onTap: () {}, child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))]), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.check_circle, color: AppColors.textOnPrimary, size: 20), const SizedBox(width: 8), const Text('Approve Driver', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textOnPrimary))])))),
        ]),
      ),
    );
  }
}

class _QueueAvatar extends StatelessWidget { final bool isActive; final String? label; const _QueueAvatar({this.isActive = false, this.label}); @override Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [Container(width: 56, height: 56, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isActive ? AppColors.primary : Colors.transparent, width: 2), color: AppColors.slate100), child: Icon(Icons.person, size: 28, color: isActive ? AppColors.slate600 : AppColors.slate400.withValues(alpha: 0.6))), if (isActive && label != null) Container(margin: const EdgeInsets.only(top: 4), padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)), child: Text(label!, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 8, fontWeight: FontWeight.w700, color: AppColors.textOnPrimary)))]); }
class _SectionHeader extends StatelessWidget { final String title; final String? badge; final Color? badgeColor; const _SectionHeader({required this.title, this.badge, this.badgeColor}); @override Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(title, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppColors.slate500)), if (badge != null) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: (badgeColor ?? AppColors.primary).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Text(badge!, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700, color: badgeColor ?? AppColors.primary)))]); }
class _DocThumb extends StatelessWidget { final String label; const _DocThumb({required this.label}); @override Widget build(BuildContext context) => Column(children: [AspectRatio(aspectRatio: 3 / 2, child: Container(decoration: BoxDecoration(color: AppColors.slate200, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.borderMedium)), child: const Icon(Icons.badge, size: 32, color: AppColors.slate400))), const SizedBox(height: 4), Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.slate500))]); }
class _VehicleThumb extends StatelessWidget { @override Widget build(BuildContext context) => Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.slate200, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.directions_car, size: 28, color: AppColors.slate400)); }
