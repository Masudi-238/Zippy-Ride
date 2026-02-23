import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/ride.dart';
import '../../../widgets/zippy_button.dart';
import '../providers/rider_provider.dart';

/// Ride selection screen matching Rider Dashboad selection.html.
class RideSelectionScreen extends StatelessWidget {
  const RideSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rider = context.watch<RiderProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map background
          Positioned.fill(
            child: Container(
              color: AppColors.slate200,
              child: Stack(
                children: [
                  Center(child: Icon(Icons.map_outlined, size: 64, color: AppColors.slate300)),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    left: MediaQuery.of(context).size.width * 0.3,
                    child: _MapPin(color: AppColors.primary, icon: Icons.my_location, label: 'Pickup'),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.35,
                    right: MediaQuery.of(context).size.width * 0.2,
                    child: _MapPin(color: AppColors.slate900, icon: Icons.location_on, label: 'Drop-off'),
                  ),
                ],
              ),
            ),
          ),

          // Top nav
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleButton(icon: Icons.arrow_back_ios_new, onTap: () => Navigator.of(context).pop()),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12)],
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Text('FINDING RIDES', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
                      ]),
                    ),
                    _CircleButton(icon: Icons.info_outline, onTap: () {}),
                  ],
                ),
              ),
            ),
          ),

          // Bottom sheet
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -4))],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(margin: const EdgeInsets.only(top: 12), width: 48, height: 6, decoration: BoxDecoration(color: AppColors.slate200, borderRadius: BorderRadius.circular(3))),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Choose a ride', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
                          const SizedBox(height: 20),
                          _RideOptionCard(type: RideType.economy, name: 'Economy', price: '\$12.50', eta: '3 min away', icon: Icons.directions_car, badge: 'BEST', isSelected: rider.selectedRideType == RideType.economy, onTap: () => rider.selectRideType(RideType.economy)),
                          const SizedBox(height: 12),
                          _RideOptionCard(type: RideType.xl, name: 'ZippyXL', price: '\$18.25', eta: '6 min away', icon: Icons.airport_shuttle, isSelected: rider.selectedRideType == RideType.xl, onTap: () => rider.selectRideType(RideType.xl)),
                          const SizedBox(height: 12),
                          _RideOptionCard(type: RideType.luxury, name: 'Luxury', price: '\$29.90', eta: '9 min away', icon: Icons.electric_car, isSelected: rider.selectedRideType == RideType.luxury, onTap: () => rider.selectRideType(RideType.luxury)),
                          const SizedBox(height: 24),
                          // Payment
                          Container(
                            padding: const EdgeInsets.only(top: 24),
                            decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))),
                            child: Row(children: [
                              Container(width: 48, height: 32, decoration: BoxDecoration(color: AppColors.slate100, borderRadius: BorderRadius.circular(4)), child: const Icon(Icons.contactless, size: 20, color: AppColors.slate600)),
                              const SizedBox(width: 12),
                              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Apple Pay', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700)),
                                Text('PERSONAL ACCOUNT', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 9, fontWeight: FontWeight.w500, letterSpacing: 0.5, color: AppColors.slate500)),
                              ])),
                              Text('Change', style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                            ]),
                          ),
                          const SizedBox(height: 24),
                          ZippyButton(text: 'Book ${_getRideTypeName(rider.selectedRideType)} Now', trailingIcon: Icons.arrow_forward, onPressed: () => rider.bookRide(), isLoading: rider.isLoading),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _getRideTypeName(RideType type) {
    switch (type) { case RideType.economy: return 'Economy'; case RideType.xl: return 'ZippyXL'; case RideType.luxury: return 'Luxury'; }
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 12)]),
        child: Icon(icon, size: 18),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _MapPin({required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8)]),
          child: Icon(icon, color: color == AppColors.primary ? AppColors.slate900 : Colors.white, size: 16),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), border: Border.all(color: AppColors.borderMedium), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)]),
          child: Text(label, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

class _RideOptionCard extends StatelessWidget {
  final RideType type;
  final String name;
  final String price;
  final String eta;
  final IconData icon;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _RideOptionCard({required this.type, required this.name, required this.price, required this.eta, required this.icon, this.badge, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.slate50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderLight, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 64, height: 64,
              decoration: BoxDecoration(color: isSelected ? AppColors.primaryLight : AppColors.slate200, borderRadius: BorderRadius.circular(12)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(icon, size: 28, color: isSelected ? AppColors.textPrimary : AppColors.slate500),
                  if (badge != null) Positioned(top: -2, right: -2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white, width: 1)), child: Text(badge!, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.textPrimary)))),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(name, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(price, style: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 18, fontWeight: FontWeight.w900)),
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.schedule, size: 14, color: isSelected ? AppColors.primary : AppColors.slate400),
                    const SizedBox(width: 4),
                    Text(eta, style: TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.slate600)),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
