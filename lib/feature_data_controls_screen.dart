import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_spacing.dart';
import 'shared_settings_provider.dart';

class DataControlsScreen extends ConsumerWidget {
  const DataControlsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(dataControlsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Controls'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Help improve Wigma 8'),
            subtitle: const Text('Allow anonymized usage data to improve the product'),
            value: enabled,
            onChanged: (v) => ref.read(dataControlsEnabledProvider.notifier).state = v,
          ),
        ),
      ),
    );
  }
}
