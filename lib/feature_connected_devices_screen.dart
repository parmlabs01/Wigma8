import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'core_app_router.dart';

class ConnectedDevicesScreen extends StatelessWidget {
  const ConnectedDevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connected Devices'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.smartphone, color: AppColors.primaryNavy),
                title: Text('This device'),
                subtitle: Text('Active now'),
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton(
                onPressed: () async {
                  await Supabase.instance.client.auth.signOut(scope: SignOutScope.global);
                  if (context.mounted) context.go(AppRoutes.signIn);
                },
                child: const Text('Sign Out of All Devices'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
