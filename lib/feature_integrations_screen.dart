import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';

class IntegrationsScreen extends StatelessWidget {
  const IntegrationsScreen({super.key});

  static const _items = [
    ('Canva', Icons.brush_outlined),
    ('Google Drive', Icons.add_to_drive_outlined),
    ('Instagram', Icons.camera_alt_outlined),
    ('Slack', Icons.chat_bubble_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integrations'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            for (final (name, icon) in _items)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(icon, color: AppColors.primaryNavy),
                title: Text(name),
                trailing: const Text('Coming soon', style: TextStyle(color: AppColors.textSecondary)),
              ),
          ],
        ),
      ),
    );
  }
}
