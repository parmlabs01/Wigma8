 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'feature_splash_screen.dart';
import 'feature_auth_sign_in_screen.dart';
import 'feature_auth_sign_up_screen.dart';
import 'feature_auth_forgot_password_screen.dart';
import 'feature_home_screen.dart';
import 'feature_generator_input_screen.dart';
import 'feature_generator_results_screen.dart';
import 'feature_activity_screen.dart';
import 'feature_upgrade_screen.dart';
import 'feature_drafts_screen.dart';
import 'feature_profile_screen.dart';
import 'feature_settings_screen.dart';
import 'shared_auth_provider.dart';

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const generatorInput = '/generate';
  static const generatorResults = '/generate/results';
  static const activity = '/activity';
  static const upgrade = '/upgrade';
  static const drafts = '/drafts';
  static const profile = '/profile';
  static const settings = '/settings';

  // Routes that require a signed-in user. Home and Upgrade stay public
  // so people can browse before creating an account, matching ChatGPT's
  // "try before you sign up" pattern.
  static const _protected = {
    generatorInput,
    generatorResults,
    activity,
    drafts,
    profile,
    settings,
  };

  static bool isProtected(String location) {
    return _protected.any((p) => location == p || location.startsWith('$p/') || location.startsWith('$p?'));
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == AppRoutes.signIn ||
          state.matchedLocation == AppRoutes.signUp ||
          state.matchedLocation == AppRoutes.forgotPassword;
      final onSplash = state.matchedLocation == AppRoutes.splash;

      final isAuthed = authState.valueOrNull != null;

      if (onSplash) return null; // splash handles its own timed redirect

      final needsAuth = AppRoutes.isProtected(state.matchedLocation);

      if (!isAuthed && needsAuth) {
        // Send them to sign in, remembering where they wanted to go.
        return '${AppRoutes.signIn}?redirect=${Uri.encodeComponent(state.matchedLocation)}';
      }
      if (isAuthed && loggingIn) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.generatorInput,
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'logo';
          return GeneratorInputScreen(designTypeSlug: type);
        },
      ),
      GoRoute(
        path: AppRoutes.generatorResults,
        builder: (context, state) => const GeneratorResultsScreen(),
      ),
      GoRoute(
        path: AppRoutes.activity,
        builder: (context, state) => const ActivityScreen(),
      ),
      GoRoute(
        path: AppRoutes.upgrade,
        builder: (context, state) => const UpgradeScreen(),
      ),
      GoRoute(
        path: AppRoutes.drafts,
        builder: (context, state) => const DraftsScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});     
