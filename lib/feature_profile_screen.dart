import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'shared_auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.surfaceMuted,
                    child: Icon(Icons.person, size: 40, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    user?.userMetadata?['full_name'] ?? 'Your Name',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    user?.email ?? '—',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _ProfileTile(icon: Icons.workspace_premium_outlined, label: 'Subscription Plan', trailing: 'Free'),
            _ProfileTile(icon: Icons.receipt_long_outlined, label: 'Billing'),
            _ProfileTile(icon: Icons.folder_open_outlined, label: 'Saved Projects'),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton(
              onPressed: () async {
                await ref.read(authControllerProvider).signOut();
                if (context.mounted) context.go(AppRoutes.signIn);
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;

  const _ProfileTile({required this.icon, required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryNavy),
      title: Text(label),
      trailing: trailing != null
          ? Text(trailing!, style: const TextStyle(color: AppColors.textSecondary))
          : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: () {},
    );
  }
}
