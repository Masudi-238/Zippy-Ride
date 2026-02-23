import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/zippy_button.dart';
import '../../../widgets/zippy_text_field.dart';
import '../../../widgets/zippy_app_bar.dart';
import '../../../widgets/loading_overlay.dart';
import '../providers/auth_provider.dart';

/// Registration screen matching the Zippy Ride HTML design.
/// Features: step progress indicator, role selector (Rider/Driver),
/// full name, email, phone, password fields, terms agreement.
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedRole = 'rider';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.register(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed('/rider-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: LoadingOverlay(
        isLoading: authProvider.isLoading,
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundLight.withValues(alpha: 0.8),
                border: const Border(
                  bottom: BorderSide(color: AppColors.borderMedium, width: 1),
                ),
              ),
              child: const ZippyAppBar(title: 'Create Account'),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Progress Indicator
                      _buildProgressIndicator(),
                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        'Join Zippy Ride',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your details and choose how you\'d like to use the app.',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14,
                          color: AppColors.slate600,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Role Selector
                      _buildRoleSelector(),
                      const SizedBox(height: 32),

                      // Error message
                      if (authProvider.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: AppColors.error, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  authProvider.errorMessage!,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Form Fields
                      ZippyTextField(
                        label: 'Full Name',
                        hint: 'John Doe',
                        prefixIcon: Icons.person_outline,
                        controller: _nameController,
                        validator: Validators.validateFullName,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),

                      ZippyTextField(
                        label: 'Email Address',
                        hint: 'john@example.com',
                        prefixIcon: Icons.mail_outline,
                        controller: _emailController,
                        validator: Validators.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),

                      ZippyTextField(
                        label: 'Phone Number',
                        hint: '+1 (555) 000-0000',
                        prefixIcon: Icons.phone_outlined,
                        controller: _phoneController,
                        validator: Validators.validatePhone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),

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
                      const SizedBox(height: 40),

                      // Create Account Button
                      ZippyButton(
                        text: 'Create Account',
                        trailingIcon: Icons.arrow_forward,
                        onPressed: _handleRegister,
                        isLoading: authProvider.isLoading,
                      ),
                      const SizedBox(height: 24),

                      // Terms
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text.rich(
                          TextSpan(
                            text: 'By clicking "Create Account", you agree to our ',
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              color: AppColors.slate500,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(text: '.'),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 80), // Bottom nav spacing
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the step progress indicator matching the HTML design.
  Widget _buildProgressIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'STEP 1 OF 3',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: 1.0,
              ),
            ),
            const Text(
              'Personal Details',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                color: AppColors.slate500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: 0.3333,
            minHeight: 6,
            backgroundColor: AppColors.slate200,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }

  /// Builds the role selector (Rider / Driver) matching HTML grid-cols-2.
  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose your role',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.slate700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _RoleOption(
              label: 'Rider',
              icon: Icons.person_pin_circle_outlined,
              isSelected: _selectedRole == 'rider',
              onTap: () => setState(() => _selectedRole = 'rider'),
            )),
            const SizedBox(width: 16),
            Expanded(child: _RoleOption(
              label: 'Driver',
              icon: Icons.directions_car_outlined,
              isSelected: _selectedRole == 'driver',
              onTap: () => setState(() => _selectedRole = 'driver'),
            )),
          ],
        ),
      ],
    );
  }
}

/// Individual role option card matching the HTML radio button design.
class _RoleOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderMedium,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryLight
                        : AppColors.slate100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.primary : AppColors.slate600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: -8,
              right: -8,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
