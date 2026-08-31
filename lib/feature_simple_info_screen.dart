import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/go_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'core_app_router.dart';

class _InfoScaffold extends StatelessWidget {
  final String title;
  final List<String> paragraphs;
  const _InfoScaffold({required this.title, required this.paragraphs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            for (final p in paragraphs) ...[
              Text(
                p,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ),
      ),
    );
  }
}

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key});
  @override
  Widget build(BuildContext context) => const _InfoScaffold(
        title: 'Workspace',
        paragraphs: [
          'You\'re on your Personal workspace.',
          'Team workspaces with shared drafts are part of the Studio plan.',
        ],
      );
}

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});
  @override
  Widget build(BuildContext context) => const _InfoScaffold(
        title: 'Storage',
        paragraphs: [
          'Your drafts and account data are stored securely online.',
          'Nothing on this device needs to be managed or cleared.',
        ],
      );
}

class AdsControlsScreen extends StatelessWidget {
  const AdsControlsScreen({super.key});
  @override
  Widget build(BuildContext context) => const _InfoScaffold(
        title: 'Ads Controls',
        paragraphs: ['Wigma 8 does not show ads.'],
      );
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Wigma 8', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'AI Graphic Design Studio',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            const Text('Version 1.0.0'),
            const SizedBox(height: AppSpacing.lg),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => context.push(AppRoutes.privacy),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'from PARM',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
