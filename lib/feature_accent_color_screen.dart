import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_spacing.dart';
import 'shared_settings_provider.dart';

class AccentColorScreen extends ConsumerWidget {
  const AccentColorScreen({super.key});

  static const _colors = [
    Color(0xFF3B82F6), // brand blue
    Color(0xFF8B5CF6), // purple
    Color(0xFFEC4899), // pink
    Color(0xFF10B981), // green
    Color(0xFFF59E0B), // amber
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(accentColorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accent Color'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              for (final c in _colors)
                GestureDetector(
                  onTap: () => ref.read(accentColorProvider.notifier).state = c,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      border: selected.value == c.value
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
