import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: Colors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}

class SocialAuthButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? svgAsset;
  final VoidCallback onPressed;

  const SocialAuthButton({
    super.key,
    required this.label,
    this.icon,
    this.svgAsset,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (svgAsset != null)
              SvgPicture.asset(svgAsset!, width: 20, height: 20)
            else if (icon != null)
              Icon(icon, size: 20, color: AppColors.textPrimary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'or',
            style: TextStyle(color: AppColors.textSecondary.withOpacity(0.8)),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
