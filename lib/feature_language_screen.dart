import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'shared_settings_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    'English',
    'Spanish',
    'French',
    'Portuguese',
    'German',
    'Arabic',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                'This sets your preferred language for the interface.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ),
            for (final lang in _languages)
              RadioListTile<String>(
                value: lang,
                groupValue: selected,
                title: Text(lang),
                activeColor: AppColors.primaryNavy,
                onChanged: (v) {
                  if (v != null) {
                    ref.read(languageProvider.notifier).state = v;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language set to $v')),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
