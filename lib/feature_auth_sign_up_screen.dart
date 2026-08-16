import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'shared_auth_provider.dart';
import 'shared_auth_buttons.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authControllerProvider).signUp(
            fullName: _fullName.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
          );
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      setState(() => _error = 'Could not create account. Try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create your account',
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Start designing in seconds with AI.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                TextFormField(
                  controller: _fullName,
                  decoration: const InputDecoration(hintText: 'Full Name'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (v) =>
                      (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _confirmPassword,
                  obscureText: _obscure,
                  decoration: const InputDecoration(hintText: 'Confirm Password'),
                  validator: (v) => (v != _password.text) ? 'Passwords do not match' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(_error!, style: const TextStyle(color: AppColors.danger)),
                ],
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Create Account',
                  loading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: AppSpacing.lg),
                const OrDivider(),
                const SizedBox(height: AppSpacing.lg),
                SocialAuthButton(
                  label: 'Continue with Google',
                  svgAsset: 'assets/images/google_logo.svg',
                  onPressed: () => ref.read(authControllerProvider).signInWithGoogle(),
                ),
                const SizedBox(height: AppSpacing.md),
                SocialAuthButton(
                  label: 'Continue with Apple',
                  icon: Icons.apple,
                  onPressed: () => ref.read(authControllerProvider).signInWithApple(),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
