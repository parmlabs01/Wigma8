import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'core_app_router.dart';
import 'shared_auth_provider.dart';

/// Previous Activity panel. Wire to a Supabase-backed Riverpod provider
/// (`activity_provider.dart`, filtered by user_id) once the schema exists.
class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wigma 8',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Previous activity',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.primaryNavy.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.access_time_rounded,
                          color: AppColors.primaryNavy, size: 28),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'No previous activity',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Saved generations will appear here.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            // Pinned account footer, similar to ChatGPT's sidebar footer.
            InkWell(
              onTap: () {
                context.pop();
                context.push(AppRoutes.profile);
              },
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.surfaceMuted,
                      child: Icon(Icons.person, size: 20, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.userMetadata?['full_name'] ?? 'Your Account',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            user?.email ?? '',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                context.pop();
                context.push(AppRoutes.settings);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: AppColors.textSecondary),
                    SizedBox(width: AppSpacing.sm),
                    Text('Settings'),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                await ref.read(authControllerProvider).signOut();
                if (context.mounted) context.go(AppRoutes.signIn);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.danger),
                    SizedBox(width: AppSpacing.sm),
                    Text('Log Out', style: TextStyle(color: AppColors.danger)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
