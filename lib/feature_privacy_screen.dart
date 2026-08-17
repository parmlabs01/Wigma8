import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _Section(
              title: 'What we store',
              body:
                  'Your email, full name, and authentication details are stored '
                  'securely with Supabase. Designs you generate and save are '
                  'stored under your account so you can access them later.',
            ),
            _Section(
              title: 'What we don\'t do',
              body:
                  'We don\'t sell your data, and we don\'t share your prompts '
                  'or generated designs with third parties beyond the AI '
                  'providers needed to create them.',
            ),
            _Section(
              title: 'Your controls',
              body:
                  'You can sign out at any time from the menu or Profile tab. '
                  'For account deletion or a full data export, use Account '
                  'Management in Settings.',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
