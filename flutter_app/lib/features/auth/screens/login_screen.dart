import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/zippy_button.dart';
import '../../../widgets/zippy_text_field.dart';
import '../../../widgets/loading_overlay.dart';
import '../providers/auth_provider.dart';
import '../../../app.dart';

/// Login screen matching the Zippy Ride login HTML design.
/// Features: email/phone input, password with visibility toggle,
/// social login buttons, forgot password link, sign up link.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      emailOrPhone: _emailPhoneController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Navigate based on user role
      final user = authProvider.user;
      if (user != null) {
        final route = ZippyRideApp.getDashboardRoute(user.role);
        Navigator.of(context).pushReplacementNamed(route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: LoadingOverlay(
        isLoading: authProvider.isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 40,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Stack(
                children: [
                  // Geometric accent circles (from HTML design)
                  Positioned(
                    top: -10,
                    right: -10,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          width: 10,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 160,
                    left: -40,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  // Main content
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Top navigation area
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.slate100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    size: 16,
                                    color: AppColors.slate600,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),

                          // Branding Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                // Bolt icon in green container
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.bolt,
                                    color: AppColors.primary,
                                    size: 48,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Zippy Ride',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.5,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Your fast track to anywhere',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.slate500,
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),

                          // Form Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                // Error message
                                if (authProvider.errorMessage != null) ...[
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.error
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline,
                                          color: AppColors.error,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            authProvider.errorMessage!,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.error,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Email/Phone Input
                                ZippyTextField(
                                  label: 'Email or Phone',
                                  hint: 'driver@zippyride.com',
                                  prefixIcon: Icons.person_outline,
                                  controller: _emailPhoneController,
                                  validator: Validators.validateEmailOrPhone,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(height: 20),

                                // Password Input
                                ZippyTextField(
                                  label: 'Password',
                                  hint: '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                                  prefixIcon: Icons.lock_outline,
                                  controller: _passwordController,
                                  validator: Validators.validatePassword,
                                  obscureText: _obscurePassword,
                                  textInputAction: TextInputAction.done,
                                  suffix: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.slate400,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Forgot Password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigate to forgot password
                                    },
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Login Button
                                ZippyButton(
                                  text: 'Log In',
                                  trailingIcon: Icons.arrow_forward,
                                  onPressed: _handleLogin,
                                  isLoading: authProvider.isLoading,
                                ),
                              ],
                            ),
                          ),

                          // Divider
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 40,
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Divider(color: AppColors.borderLight),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    'Or continue with',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.slate400,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(color: AppColors.borderLight),
                                ),
                              ],
                            ),
                          ),

                          // Social Login Buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _SocialButton(
                                    label: 'Google',
                                    icon: Icons.g_mobiledata,
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _SocialButton(
                                    label: 'Apple',
                                    icon: Icons.apple,
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Footer - Sign Up
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 14,
                                    color: AppColors.slate500,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                      '/register',
                                    );
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // iOS indicator bar
                          Container(
                            width: 128,
                            height: 6,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: AppColors.slate200,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Social login button matching the HTML grid-cols-2 design.
class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppColors.slate700),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.slate700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
