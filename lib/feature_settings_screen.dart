import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'core_app_router.dart';
import 'shared_theme_provider.dart';
import 'shared_auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final user = ref.watch(authStateProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _SectionLabel('Personalization'),
            _Tile(
              icon: Icons.tune,
              label: 'Personalization',
              onTap: () => context.push(AppRoutes.personalization),
            ),
            _Tile(
              icon: Icons.palette_outlined,
              label: 'Brand Kit',
              onTap: () => context.push('${AppRoutes.generatorInput}?type=brandKit'),
            ),
            _Tile(
              icon: Icons.extension_outlined,
              label: 'Integrations',
              onTap: () => context.push(AppRoutes.integrations),
            ),
            const Divider(height: AppSpacing.xxl),
            _SectionLabel('Account'),
            _Tile(
              icon: Icons.workspaces_outlined,
              label: 'Workspace',
              trailing: 'Personal',
              onTap: () => context.push(AppRoutes.workspace),
            ),
            _Tile(
              icon: Icons.workspace_premium_outlined,
              label: 'Upgrade Plan',
              onTap: () => context.push(AppRoutes.upgrade),
            ),
            _Tile(
              icon: Icons.group_outlined,
              label: 'Team Access',
              onTap: () => context.push(AppRoutes.teamAccess),
            ),
            _Tile(
              icon: Icons.shield_outlined,
              label: 'Content Filters',
              onTap: () => context.push(AppRoutes.contentFilters),
            ),
            _Tile(
              icon: Icons.email_outlined,
              label: 'Email',
              trailing: user?.email ?? '—',
              onTap: () {},
            ),
            const Divider(height: AppSpacing.xxl),
            _SectionLabel('Appearance'),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.brightness_6_outlined, color: AppColors.primaryNavy),
              title: const Text('Appearance'),
              trailing: DropdownButton<ThemeMode>(
                value: themeMode,
                underline: const SizedBox.shrink(),
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text('System Default')),
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                ],
                onChanged: (v) {
                  if (v != null) ref.read(themeModeProvider.notifier).state = v;
                },
              ),
            ),
            _Tile(
              icon: Icons.color_lens_outlined,
              label: 'Accent Color',
              onTap: () => context.push(AppRoutes.accentColor),
            ),
            const Divider(height: AppSpacing.xxl),
            _SectionLabel('General Settings'),
            _Tile(icon: Icons.settings_outlined, label: 'General', onTap: () => context.push(AppRoutes.general)),
            _Tile(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () => context.push(AppRoutes.notifications)),
            _Tile(icon: Icons.download_outlined, label: 'Default Export', onTap: () => context.push(AppRoutes.defaultExport)),
            _Tile(icon: Icons.health_and_safety_outlined, label: 'Safety', onTap: () => context.push(AppRoutes.safety)),
            _Tile(icon: Icons.lock_outline, label: 'Security and Login', onTap: () => context.push(AppRoutes.accountManagement)),
            _Tile(icon: Icons.devices_outlined, label: 'Connected Devices', onTap: () => context.push(AppRoutes.connectedDevices)),
            _Tile(icon: Icons.storage_outlined, label: 'Storage', onTap: () => context.push(AppRoutes.storage)),
            _Tile(icon: Icons.data_usage_outlined, label: 'Data Controls', onTap: () => context.push(AppRoutes.dataControls)),
            _Tile(icon: Icons.block_outlined, label: 'Ads Controls', onTap: () => context.push(AppRoutes.adsControls)),
            _Tile(icon: Icons.bug_report_outlined, label: 'Report Bug', onTap: () => context.push(AppRoutes.reportBug)),
            _Tile(icon: Icons.info_outline, label: 'About', onTap: () => context.push(AppRoutes.about)),
            const Divider(height: AppSpacing.xxl),
            _Tile(
              icon: Icons.logout,
              label: 'Log Out',
              iconColor: AppColors.danger,
              labelColor: AppColors.danger,
              onTap: () async {
                await ref.read(authControllerProvider).signOut();
                if (context.mounted) context.go(AppRoutes.signIn);
              },
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
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color? iconColor;
  final Color? labelColor;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? AppColors.primaryNavy),
      title: Text(label, style: TextStyle(color: labelColor)),
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
