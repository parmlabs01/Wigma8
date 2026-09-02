import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core_app_constants.dart';
import 'core_app_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Added a 4th field: the cover image asset for each card.
  static const _quickActions = <(DesignType, IconData, String, String)>[
    (DesignType.logo, Icons.auto_awesome_outlined, 'Brand marks & wordmarks',
        'assets/images/cover_logo.jpg'),
    (DesignType.flyer, Icons.image_outlined, 'Posters & promos',
        'assets/images/cover_flyer.jpg'),
    (DesignType.poster, Icons.videocam_outlined, 'Key frames & covers',
        'assets/images/cover_poster.jpg'),
    (DesignType.social, Icons.content_cut_outlined, 'Re-style a frame',
        'assets/images/cover_social.jpg'),
    (DesignType.businessCard, Icons.badge_outlined, 'Contact-ready cards',
        'assets/images/cover_business_card.jpg'),
    (DesignType.banner, Icons.panorama_outlined, 'Wide-format banners',
        'assets/images/cover_banner.jpg'),
    (DesignType.videoThumbnail, Icons.video_camera_back_outlined,
        'Eye-catching thumbnails', 'assets/images/cover_video_thumbnail.jpg'),
    (DesignType.brandKit, Icons.palette_outlined, 'Full brand system',
        'assets/images/cover_brand_kit.jpg'),
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
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final (type, icon, subtitle, coverImage) =
                        _quickActions[index];
                    return _ActionCard(
                      title: type.label,
                      subtitle: subtitle,
                      icon: icon,
                      coverImage: coverImage,
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
              sliver: SliverToBoxAdapter(child: _DraftsSection(context: context)),
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
            icon: const Icon(Icons.menu),
            tooltip: 'Previous activity',
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/wigma8_logo.png',
                height: 24,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.upgrade),
            icon: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.primaryNavy,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.workspace_premium_outlined,
                  color: Colors.white, size: 18),
            ),
            tooltip: 'Upgrade',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                ),
            children: [
              const TextSpan(text: 'Design anything,\n'),
              TextSpan(
                text: 'in one prompt.',
                style: TextStyle(color: AppColors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Pick a canvas and describe your project. Wigma 8 handles the rest.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String coverImage;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.coverImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Cover image
            Image.asset(
              coverImage,
              fit: BoxFit.cover,
            ),
            // Gradient scrim so white text stays legible over any image
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.65),
                  ],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),
            // Icon badge + title/subtitle overlay
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                            ),
                      ),
                    ],
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

class _DraftsSection extends StatelessWidget {
  final BuildContext context;
  const _DraftsSection({required this.context});

  @override
  Widget build(BuildContext context) {
    // Empty state — wire to a Riverpod provider backed by
    // Supabase (`drafts` table filtered by user_id) once available.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Drafts', style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              onPressed: () => context.push(AppRoutes.drafts),
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
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
              const Icon(Icons.folder_outlined,
                  color: AppColors.textSecondary, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No drafts yet — your recent generations will appear here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push(
              '${AppRoutes.generatorInput}?type=logo',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: const Text('Start Designing'),
          ),
        ),
      ],
    );
  }
}
