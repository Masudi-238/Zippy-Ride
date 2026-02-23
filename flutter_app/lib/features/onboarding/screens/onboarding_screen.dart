import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/zippy_button.dart';

/// Main onboarding screen with PageView matching the HTML designs.
/// Page 1: Welcome to Zippy Ride (onboardCode.html)
/// Page 2: Smart Wallet & Multi-Stops (OnboardFuturescode.html)
/// Page 3: Driver Benefits (onboaddriverBenefitcode.html)
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      illustrationIcon: Icons.directions_car,
      illustrationBgColor: AppColors.primaryLight,
      title: 'Welcome to ',
      titleHighlight: 'Zippy Ride',
      description:
          'Experience the fastest way to get around your city. Reliable rides at your fingertips, anytime, anywhere.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBo3eYLEDCLDcksEOIjFkvaH4xIhWFDFmDpjVF18LkfcBJ1I0wY1ShbrfPM5Hq0nI3JBIXOHPvX9WpCeozDiTEVrkT8nJNx4W0x1UQxThlLTjSvTB6VYOwxnVSl3KNozydlmgBlVwYD-qxSSfeBnqTo0SNNJcCMbB5AGKiimR3Ctd3ydko3WjEWCTVa_T9QfOmJrIdMMvbUefy6CfGPdvuJkpul57CxbyJHDC-Fm1rylrjMhXpV0wzigKWYPtC4KOkX-O4VWSZQlCg',
    ),
    _OnboardingPageData(
      illustrationIcon: Icons.account_balance_wallet,
      illustrationBgColor: AppColors.primaryLight,
      title: 'Smart Wallet & Multi-Stops',
      titleHighlight: null,
      description:
          'Plan complex trips with up to 5 stops effortlessly. Keep your funds ready in the Zippy Wallet for instant, one-tap payments every time you ride.',
      imageUrl: null,
      hasCustomIllustration: true,
    ),
    _OnboardingPageData(
      illustrationIcon: Icons.trending_up,
      illustrationBgColor: AppColors.primaryLight,
      title: 'Drive, Earn, ',
      titleHighlight: 'Repeat.',
      description:
          'Join thousands of Zippy Ride drivers. Set your own schedule, track your earnings in real-time, and get paid daily.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD7ySRWowLa6cKZVnA5JuCC07CgV9sfM7nifqr7B7NqZQNIb9k7Uf41greq6MrY5_Lz0_clpk0fG7hiBZxtu92uxczUK7GawkUuoke-OjXmAxWLsBU0YvDfNah5w_gI5WBgTM5xPIjAaM9jP0G27MwF4pfMDN5N6AiCOrigYTPX6uGXodMJTnLTmRRPfqIejjtewi61vsoJ2UHPcnuOUBQOKdRpQ3NktrbHbtK14Yd6xigel5EsL-Z8zI8qEB0bO2in7e1RJQeXreo',
      hasDriverBenefits: true,
    ),
  ];

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void _onBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onSkip() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button (top right, as in HTML)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: _currentPage > 0
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  if (_currentPage > 0)
                    GestureDetector(
                      onTap: _onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.slate200.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: _onSkip,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPage(data: page);
                },
              ),
            ),

            // Bottom section: indicators + buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                children: [
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.primary
                              : AppColors.slate300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  if (_currentPage < _pages.length - 1) ...[
                    ZippyButton(
                      text: 'Next',
                      trailingIcon: Icons.arrow_forward,
                      onPressed: _onNext,
                    ),
                  ] else ...[
                    // Last page: Get Started button
                    ZippyButton(
                      text: 'Get Started',
                      onPressed: _onSkip,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.slate400,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed('/login');
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primary,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),

                  // iOS home indicator
                  Container(
                    width: 128,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.slate200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data model for each onboarding page.
class _OnboardingPageData {
  final IconData illustrationIcon;
  final Color illustrationBgColor;
  final String title;
  final String? titleHighlight;
  final String description;
  final String? imageUrl;
  final bool hasCustomIllustration;
  final bool hasDriverBenefits;

  const _OnboardingPageData({
    required this.illustrationIcon,
    required this.illustrationBgColor,
    required this.title,
    this.titleHighlight,
    required this.description,
    this.imageUrl,
    this.hasCustomIllustration = false,
    this.hasDriverBenefits = false,
  });
}

/// Single onboarding page widget.
class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: data.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Image.network(
                              data.imageUrl!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => Icon(
                                data.illustrationIcon,
                                size: 120,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          // Floating earnings card for driver page
                          if (data.hasDriverBenefits)
                            Positioned(
                              bottom: 24,
                              right: 24,
                              child: _buildEarningsCard(),
                            ),
                        ],
                      ),
                    )
                  : data.hasCustomIllustration
                      ? _buildWalletIllustration()
                      : Center(
                          child: Icon(
                            data.illustrationIcon,
                            size: 120,
                            color: AppColors.primary,
                          ),
                        ),
            ),
          ),
          const SizedBox(height: 40),

          // Title text
          if (data.titleHighlight != null)
            Text.rich(
              TextSpan(
                text: data.title,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: data.titleHighlight,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            )
          else
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          const SizedBox(height: 16),

          // Description
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.slate600,
              height: 1.5,
            ),
          ),

          // Driver benefits grid
          if (data.hasDriverBenefits) ...[
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(child: _BenefitChip(
                  icon: Icons.schedule,
                  label: 'Flexible Hours',
                )),
                const SizedBox(width: 16),
                Expanded(child: _BenefitChip(
                  icon: Icons.payments_outlined,
                  label: 'Daily Payouts',
                )),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL EARNINGS',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.slate400,
                ),
              ),
              const Icon(Icons.trending_up, color: AppColors.primary, size: 14),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '\$1,240.50',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dotted pattern background
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        // Map card
        Positioned(
          top: 40,
          child: Container(
            width: 200,
            height: 120,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                ),
              ],
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.radio_button_checked,
                        color: AppColors.primary, size: 14),
                    const SizedBox(width: 8),
                    Container(
                      height: 6,
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.slate300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: AppColors.primary, size: 14),
                    const SizedBox(width: 8),
                    Container(
                      height: 6,
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.slate300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: AppColors.primary, size: 14),
                    const SizedBox(width: 8),
                    Container(
                      height: 6,
                      width: 75,
                      decoration: BoxDecoration(
                        color: AppColors.slate300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Wallet card
        Positioned(
          bottom: 30,
          child: Container(
            width: 100,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}

/// Benefit chip for the driver onboarding page.
class _BenefitChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BenefitChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.slate100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.slate700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
