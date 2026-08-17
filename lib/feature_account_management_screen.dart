import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'shared_auth_provider.dart';

class AccountManagementScreen extends ConsumerWidget {
  const AccountManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Management'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_reset_outlined, color: AppColors.primaryNavy),
              title: const Text('Reset Password'),
              subtitle: Text('Send a reset link to ${user?.email ?? "your email"}'),
              onTap: () async {
                if (user?.email == null) return;
                await ref.read(authControllerProvider).sendPasswordReset(user!.email!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset email sent')),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.delete_outline, color: AppColors.danger),
              title: const Text('Delete Account', style: TextStyle(color: AppColors.danger)),
              subtitle: const Text('Permanently remove your account and data'),
              onTap: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Account deletion requires manual processing to make sure your data '
          'is fully and safely removed. Please contact support to request '
          'deletion, and we\'ll take care of it from there.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
