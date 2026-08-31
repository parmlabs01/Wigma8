import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'core_app_router.dart';
import 'shared_settings_provider.dart';

class DefaultExportScreen extends ConsumerWidget {
  const DefaultExportScreen({super.key});

  static const _formats = ['PNG', 'JPG', 'PDF'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final format = ref.watch(defaultExportFormatProvider);
    final hd = ref.watch(hdExportEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Default Export'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Format', style: Theme.of(context).textTheme.titleMedium),
            for (final f in _formats)
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                value: f,
                groupValue: format,
                title: Text(f),
                activeColor: AppColors.primaryNavy,
                onChanged: (v) {
                  if (v != null) ref.read(defaultExportFormatProvider.notifier).state = v;
                },
              ),
            const Divider(height: AppSpacing.xxl),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('HD Exports'),
              subtitle: const Text('Requires Pro'),
              value: hd,
              onChanged: (v) {
                if (v) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('HD exports require Pro — upgrade to unlock'),
                      action: SnackBarAction(
                        label: 'Upgrade',
                        onPressed: () => context.push(AppRoutes.upgrade),
                      ),
                    ),
                  );
                } else {
                  ref.read(hdExportEnabledProvider.notifier).state = false;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
