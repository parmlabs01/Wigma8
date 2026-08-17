import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'core_app_router.dart';
import 'shared_theme_provider.dart';
import 'shared_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _SectionLabel('Appearance'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Mode'),
              value: themeMode == ThemeMode.dark,
              onChanged: (v) => ref.read(themeModeProvider.notifier).state =
                  v ? ThemeMode.dark : ThemeMode.light,
            ),
            const Divider(),
            _SectionLabel('Preferences'),
            _SettingsTile(
              icon: Icons.language_outlined,
              label: 'Language',
              trailing: language,
              onTap: () => context.push(AppRoutes.language),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: const Icon(Icons.notifications_outlined, color: AppColors.primaryNavy),
              title: const Text('Notifications'),
              value: notificationsEnabled,
              onChanged: (v) => ref.read(notificationsEnabledProvider.notifier).state = v,
            ),
            const Divider(),
            _SectionLabel('Account'),
            _SettingsTile(
              icon: Icons.lock_outline,
              label: 'Privacy',
              onTap: () => context.push(AppRoutes.privacy),
            ),
            _SettingsTile(
              icon: Icons.manage_accounts_outlined,
              label: 'Account Management',
              onTap: () => context.push(AppRoutes.accountManagement),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.md),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryNavy),
      title: Text(label),
      trailing: trailing != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(trailing!, style: const TextStyle(color: AppColors.textSecondary)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            )
          : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
