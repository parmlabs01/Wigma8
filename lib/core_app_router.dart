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
import 'feature_privacy_screen.dart';
import 'feature_account_management_screen.dart';
import 'feature_change_email_screen.dart';
import 'feature_personalization_screen.dart';
import 'feature_integrations_screen.dart';
import 'feature_team_access_screen.dart';
import 'feature_content_filters_screen.dart';
import 'feature_accent_color_screen.dart';
import 'feature_general_screen.dart';
import 'feature_notifications_screen.dart';
import 'feature_default_export_screen.dart';
import 'feature_safety_screen.dart';
import 'feature_connected_devices_screen.dart';
import 'feature_data_controls_screen.dart';
import 'feature_report_bug_screen.dart';
import 'feature_simple_info_screen.dart';
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
  static const privacy = '/settings/privacy';
  static const accountManagement = '/settings/account';
  static const changeEmail = '/settings/change-email';
  static const personalization = '/settings/personalization';
  static const integrations = '/settings/integrations';
  static const workspace = '/settings/workspace';
  static const teamAccess = '/settings/team-access';
  static const contentFilters = '/settings/content-filters';
  static const accentColor = '/settings/accent-color';
  static const general = '/settings/general';
  static const notifications = '/settings/notifications';
  static const defaultExport = '/settings/default-export';
  static const safety = '/settings/safety';
  static const connectedDevices = '/settings/connected-devices';
  static const storage = '/settings/storage';
  static const dataControls = '/settings/data-controls';
  static const adsControls = '/settings/ads-controls';
  static const reportBug = '/settings/report-bug';
  static const about = '/settings/about';

  static const _protected = {
    generatorInput,
    generatorResults,
    activity,
    drafts,
    profile,
    settings,
    privacy,
    accountManagement,
    changeEmail,
    personalization,
    integrations,
    workspace,
    teamAccess,
    contentFilters,
    accentColor,
    general,
    notifications,
    defaultExport,
    safety,
    connectedDevices,
    storage,
    dataControls,
    adsControls,
    reportBug,
    about,
  };

  static bool isProtected(String location) {
    return _protected.any(
      (p) => location == p || location.startsWith('$p/') || location.startsWith('$p?'),
    );
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

      if (onSplash) return null;

      final needsAuth = AppRoutes.isProtected(state.matchedLocation);

      if (!isAuthed && needsAuth) {
        return '${AppRoutes.signIn}?redirect=${Uri.encodeComponent(state.matchedLocation)}';
      }
      if (isAuthed && loggingIn) {
        final redirect = state.uri.queryParameters['redirect'];
        return redirect != null ? Uri.decodeComponent(redirect) : AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.signIn, builder: (context, state) => const SignInScreen()),
      GoRoute(path: AppRoutes.signUp, builder: (context, state) => const SignUpScreen()),
      GoRoute(path: AppRoutes.forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: AppRoutes.home, builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.generatorInput,
        builder: (context, state) {
          final type = state.uri.queryParameters['type'] ?? 'logo';
          return GeneratorInputScreen(designTypeSlug: type);
        },
      ),
      GoRoute(path: AppRoutes.generatorResults, builder: (context, state) => const GeneratorResultsScreen()),
      GoRoute(path: AppRoutes.activity, builder: (context, state) => const ActivityScreen()),
      GoRoute(path: AppRoutes.upgrade, builder: (context, state) => const UpgradeScreen()),
      GoRoute(path: AppRoutes.drafts, builder: (context, state) => const DraftsScreen()),
      GoRoute(path: AppRoutes.profile, builder: (context, state) => const ProfileScreen()),
      GoRoute(path: AppRoutes.settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: AppRoutes.privacy, builder: (context, state) => const PrivacyScreen()),
      GoRoute(path: AppRoutes.accountManagement, builder: (context, state) => const AccountManagementScreen()),
      GoRoute(path: AppRoutes.changeEmail, builder: (context, state) => const ChangeEmailScreen()),
      GoRoute(path: AppRoutes.personalization, builder: (context, state) => const PersonalizationScreen()),
      GoRoute(path: AppRoutes.integrations, builder: (context, state) => const IntegrationsScreen()),
      GoRoute(path: AppRoutes.workspace, builder: (context, state) => const WorkspaceScreen()),
      GoRoute(path: AppRoutes.teamAccess, builder: (context, state) => const TeamAccessScreen()),
      GoRoute(path: AppRoutes.contentFilters, builder: (context, state) => const ContentFiltersScreen()),
      GoRoute(path: AppRoutes.accentColor, builder: (context, state) => const AccentColorScreen()),
      GoRoute(path: AppRoutes.general, builder: (context, state) => const GeneralScreen()),
      GoRoute(path: AppRoutes.notifications, builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: AppRoutes.defaultExport, builder: (context, state) => const DefaultExportScreen()),
      GoRoute(path: AppRoutes.safety, builder: (context, state) => const SafetyScreen()),
      GoRoute(path: AppRoutes.connectedDevices, builder: (context, state) => const ConnectedDevicesScreen()),
      GoRoute(path: AppRoutes.storage, builder: (context, state) => const StorageScreen()),
      GoRoute(path: AppRoutes.dataControls, builder: (context, state) => const DataControlsScreen()),
      GoRoute(path: AppRoutes.adsControls, builder: (context, state) => const AdsControlsScreen()),
      GoRoute(path: AppRoutes.reportBug, builder: (context, state) => const ReportBugScreen()),
      GoRoute(path: AppRoutes.about, builder: (context, state) => const AboutScreen()),
    ],
  );
});
