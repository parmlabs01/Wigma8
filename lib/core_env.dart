import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Central accessor for environment configuration.
/// Values are loaded from a local `.env` file (never committed) via
/// flutter_dotenv. See `.env.example` for the required keys.
class Env {
  Env._();

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  static String get openAiApiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get stabilityApiKey => dotenv.env['STABILITY_API_KEY'] ?? '';
  static String get fluxApiKey => dotenv.env['FLUX_API_KEY'] ?? '';
}
