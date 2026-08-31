import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'core_app_router.dart';
import 'shared_settings_provider.dart';

class PersonalizationScreen extends ConsumerWidget {
  const PersonalizationScreen({super.key});

  static const _styles = ['Balanced', 'Bold & Vibrant', 'Minimal', 'Corporate', 'Playful'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = ref.watch(personalizationStyleProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalization'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Default generation style',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Applied as a starting point whenever you generate a new design.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final s in _styles)
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                value: s,
                groupValue: style,
                title: Text(s),
                activeColor: AppColors.primaryNavy,
                onChanged: (v) {
                  if (v != null) ref.read(personalizationStyleProvider.notifier).state = v;
                },
              ),
            const Divider(height: AppSpacing.xxl),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.palette_outlined, color: AppColors.primaryNavy),
              title: const Text('Brand Kit'),
              subtitle: const Text('Save colors, fonts, and logo for consistent designs'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => context.push('${AppRoutes.generatorInput}?type=brandKit'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.extension_outlined, color: AppColors.primaryNavy),
              title: const Text('Integrations'),
              subtitle: const Text('Connect other apps and platforms'),
              trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              onTap: () => context.push(AppRoutes.integrations),
            ),
          ],
        ),
      ),
    );
  }
}
