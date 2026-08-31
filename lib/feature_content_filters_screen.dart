import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'shared_settings_provider.dart';

class ContentFiltersScreen extends ConsumerWidget {
  const ContentFiltersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(contentFiltersEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Filters'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Restrict mature content'),
                subtitle: const Text('Block explicit or unsafe content from generations'),
                value: enabled,
                onChanged: (v) => ref.read(contentFiltersEnabledProvider.notifier).state = v,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'This applies to designs generated on this account.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
