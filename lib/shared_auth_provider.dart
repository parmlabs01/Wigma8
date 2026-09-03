import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

/// Exposes the Supabase client as a Riverpod provider so it can be
/// swapped/mocked in tests.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Streams the current authenticated user (or null) so the router and
/// UI can react to sign-in / sign-out in real time.
final authStateProvider = StreamProvider<supa.User?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange.map((event) => event.session?.user);
});

/// Convenience notifier exposing sign in / sign up / sign out actions.
class AuthController {
  final SupabaseClient _client;
  AuthController(this._client);

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(OAuthProvider.google);
  }

  Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(OAuthProvider.apple);
  }

  Future<void> sendPasswordReset(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  /// Requests an email change. Supabase sends a confirmation link to the
  /// new address (and, depending on your project's auth settings, may
  /// also send one to the old address) — the change only takes effect
  /// once the link is followed.
  Future<void> updateEmail(String newEmail) async {
    await _client.auth.updateUser(
      supa.UserAttributes(email: newEmail),
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.watch(supabaseClientProvider));
});
