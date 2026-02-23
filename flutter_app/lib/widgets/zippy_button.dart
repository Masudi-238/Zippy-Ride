import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Primary action button matching the Zippy Ride design.
/// Matches the HTML: `bg-primary hover:bg-primary/90 text-slate-900 font-bold
/// py-4 rounded-xl shadow-lg shadow-primary/20`
class ZippyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData? trailingIcon;
  final IconData? leadingIcon;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;

  const ZippyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.trailingIcon,
    this.leadingIcon,
    this.width,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primary;
    final fg = textColor ?? AppColors.textOnPrimary;
    final disabled = isDisabled || isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      child: Material(
        color: disabled ? AppColors.slate200 : bg,
        borderRadius: BorderRadius.circular(12),
        elevation: disabled ? 0 : 4,
        shadowColor: AppColors.primaryShadow,
        child: InkWell(
          onTap: disabled ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leadingIcon != null && !isLoading) ...[
                  Icon(leadingIcon, color: fg, size: 20),
                  const SizedBox(width: 8),
                ],
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  )
                else
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: disabled ? AppColors.slate400 : fg,
                    ),
                  ),
                if (trailingIcon != null && !isLoading) ...[
                  const SizedBox(width: 8),
                  Icon(trailingIcon, color: fg, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Outlined variant button matching the HTML design.
class ZippyOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? leadingIcon;

  const ZippyOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.borderMedium, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leadingIcon != null) ...[
                    Icon(leadingIcon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
