import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A selectable home-screen background theme.
class HomeBackgroundTheme {
  final String id;
  final String name;
  final String assetPath; // empty string = no background image (default)

  const HomeBackgroundTheme({
    required this.id,
    required this.name,
    required this.assetPath,
  });
}

const List<HomeBackgroundTheme> homeBackgroundThemes = [
  HomeBackgroundTheme(id: 'default', name: 'Default', assetPath: ''),
  HomeBackgroundTheme(
    id: 'prism',
    name: 'Prism',
    assetPath: 'assets/images/theme_prism.jpg',
  ),
  HomeBackgroundTheme(
    id: 'speed',
    name: 'Speed',
    assetPath: 'assets/images/theme_speed.jpg',
  ),
  HomeBackgroundTheme(
    id: 'onyx',
    name: 'Onyx',
    assetPath: 'assets/images/theme_onyx.jpg',
  ),
  HomeBackgroundTheme(
    id: 'arena',
    name: 'Arena',
    assetPath: 'assets/images/theme_arena.jpg',
  ),
  HomeBackgroundTheme(
    id: 'expedition',
    name: 'Expedition',
    assetPath: 'assets/images/theme_expedition.jpg',
  ),
  HomeBackgroundTheme(
    id: 'universe',
    name: 'Universe',
    assetPath: 'assets/images/theme_universe.jpg',
  ),
];

/// Currently selected home background theme.
///
/// NOTE: this is session-only — it resets on app restart. To persist it,
/// add the `shared_preferences` package (not in pubspec.yaml yet), read
/// the saved id on startup to pick the initial value, and write the id
/// whenever the notifier's state changes.
final homeBackgroundThemeProvider = StateProvider<HomeBackgroundTheme>(
  (ref) => homeBackgroundThemes.firstWhere((t) => t.id == 'arena'),
);
