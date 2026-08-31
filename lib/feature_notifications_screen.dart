import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'shared_settings_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = ref.watch(emailNotificationsProvider);
    final push = ref.watch(pushNotificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Email Notifications'),
              subtitle: const Text('Updates about your generations and account'),
              value: email,
              onChanged: (v) => ref.read(emailNotificationsProvider.notifier).state = v,
            ),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Alerts when a design finishes generating'),
              value: push,
              onChanged: (v) => ref.read(pushNotificationsProvider.notifier).state = v,
            ),
          ],
        ),
      ),
    );
  }
}
