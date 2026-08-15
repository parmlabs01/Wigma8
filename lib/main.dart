import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

import 'core_app_constants.dart';
import 'core_env.dart';
import 'core_app_router.dart';
import 'core_app_theme.dart';
import 'shared_theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    dotenv.testLoad(fileInput: '');
  }

  await Supabase.initialize(
    url: Env.supabaseUrl.isNotEmpty
        ? Env.supabaseUrl
        : 'https://placeholder.supabase.co',
    anonKey: Env.supabaseAnonKey.isNotEmpty
        ? Env.supabaseAnonKey
        : 'placeholder-anon-key',
  );

  runApp(const ProviderScope(child: Wigma8App()));
}

class Wigma8App extends ConsumerWidget {
  const Wigma8App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
