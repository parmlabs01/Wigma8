import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'core_app_constants.dart';
import 'shared_settings_provider.dart';

class GeneralScreen extends ConsumerWidget {
  const GeneralScreen({super.key});

  static const _languages = ['English', 'Spanish', 'French', 'Portuguese', 'German', 'Arabic'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('General'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text('Language', style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final lang in _languages)
              RadioListTile<String>(
                value: lang,
                groupValue: language,
                title: Text(lang),
                activeColor: AppColors.primaryNavy,
                onChanged: (v) {
                  if (v != null) ref.read(languageProvider.notifier).state = v;
                },
              ),
            const Divider(),
            ListTile(
              title: const Text('Version'),
              trailing: Text(AppConstants.appVersion ?? '1.0.0'),
            ),
          ],
        ),
      ),
    );
  }
}
