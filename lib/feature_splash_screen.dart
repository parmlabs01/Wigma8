import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core_app_constants.dart';
import 'core_app_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'shared_auth_provider.dart';

/// Splash screen shown for exactly 3 seconds on app launch.
///
/// Layout (per PRD):
/// - Center: Wigma 8 logo + wordmark
/// - Bottom center: "from PARM" — styled subtly, the same way Meta's
///   signature appears at the bottom of Facebook / Instagram / Threads.
///   This signature must NOT appear anywhere else in the app.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    Timer(AppConstants.splashDuration, _navigateNext);
  }

  void _navigateNext() {
    if (!mounted) return;
    final isAuthed = ref.read(authStateProvider).valueOrNull != null;
    context.go(isAuthed ? AppRoutes.home : AppRoutes.signIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: FadeTransition(
                  opacity: _fade,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Wordmark logo. Swap for the real asset:
                      // Image.asset('assets/images/wigma8_logo.png', height: 64)
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: AppColors.navyGradient,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: const Icon(
                          Icons.diamond_outlined,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        AppConstants.appName,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 32,
                              color: AppColors.primaryNavy,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        AppConstants.tagline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom-center "from PARM" signature — splash screen only.
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Text(
                AppConstants.fromSignature,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
