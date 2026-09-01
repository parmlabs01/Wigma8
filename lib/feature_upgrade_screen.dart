import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

  void _handleUpgradeTap(BuildContext context, String plan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$plan — billing isn\'t connected yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _PlanCard(
              name: 'Starter',
              price: 'Free',
              features: const [
                '10 generations / day',
                'Standard resolution',
                'Drafts on this device',
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _PlanCard(
              name: 'Pro',
              price: '\$7 / mo',
              highlighted: true,
              features: const [
                'Unlimited generations',
                'HD exports',
                'Priority queue',
              ],
              ctaLabel: 'GO PRO',
              onTap: () => _handleUpgradeTap(context, 'Pro'),
            ),
            const SizedBox(height: AppSpacing.md),
            _PlanCard(
              name: 'Studio',
              price: '\$12 / mo',
              features: const [
                'Everything in Pro',
                'Brand kits',
                'Team drafts',
                'Commercial license',
              ],
              ctaLabel: 'GO STUDIO',
              onTap: () => _handleUpgradeTap(context, 'Studio'),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              "Billing isn't connected yet — plans are a preview.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final List<String> features;
  final bool highlighted;
  final String? ctaLabel;
  final VoidCallback? onTap;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.features,
    this.highlighted = false,
    this.ctaLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: highlighted ? AppColors.primaryNavy : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: highlighted ? AppColors.primaryNavy : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: highlighted ? Colors.white : AppColors.textPrimary,
                    ),
              ),
              Text(
                price,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: highlighted ? AppColors.accent : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check,
                      size: 18,
                      color: highlighted ? AppColors.accent : AppColors.primaryNavy),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      f,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: highlighted
                                ? Colors.white.withOpacity(0.85)
                                : AppColors.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (ctaLabel != null) ...[
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.workspace_premium_outlined),
                label: Text(ctaLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlighted ? AppColors.accent : AppColors.primaryNavy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return card;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: onTap,
      child: card,
    );
  }
}
