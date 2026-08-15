import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core_app_constants.dart';
import 'core_app_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'shared_quick_action_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _quickActions = <(DesignType, IconData)>[
    (DesignType.logo, Icons.diamond_outlined),
    (DesignType.flyer, Icons.description_outlined),
    (DesignType.poster, Icons.image_outlined),
    (DesignType.social, Icons.share_outlined),
    (DesignType.businessCard, Icons.badge_outlined),
    (DesignType.banner, Icons.panorama_outlined),
    (DesignType.videoThumbnail, Icons.video_camera_back_outlined),
    (DesignType.brandKit, Icons.palette_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
              ),
              sliver: SliverToBoxAdapter(child: _Hero(context: context)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, 0,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final (type, icon) = _quickActions[index];
                    return QuickActionTile(
                      label: type.label,
                      icon: icon,
                      onTap: () => context.push(
                        '${AppRoutes.generatorInput}?type=${type.slug}',
                      ),
                    );
                  },
                  childCount: _quickActions.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg, AppSpacing.xxl,
              ),
              sliver: SliverToBoxAdapter(child: _DraftsSection()),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.push(AppRoutes.activity),
            icon: const Icon(Icons.history_outlined),
            tooltip: 'Activity',
          ),
          Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final BuildContext context;
  const _Hero({required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColors.navyGradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Design Anything,\nIn One Prompt.',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Describe your project and let AI handle the design.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.75),
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => GoRouter.of(context).push(
              '${AppRoutes.generatorInput}?type=logo',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primaryNavy,
            ),
            child: const Text('Start Designing'),
          ),
        ],
      ),
    );
  }
}

class _DraftsSection extends StatelessWidget {
  const _DraftsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Drafts', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        // Empty state — wire to a Riverpod provider backed by
        // Supabase (`drafts` table filtered by user_id) once available.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              const Icon(Icons.drafts_outlined, color: AppColors.textSecondary, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No drafts yet — your recent generations will appear here.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
