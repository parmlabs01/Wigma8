import 'package:flutter/material.dart' show Brightness;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A selectable home-screen background theme.
class HomeBackgroundTheme {
  final String id;
  final String name;
  final String assetPath; // empty string = no background image (default)

  /// Overall brightness of the background image, used to pick readable
  /// text/icon colors on top of it — independent of the app's own
  /// light/dark mode. Null for the no-image default, where normal
  /// theme-based text colors already apply.
  final Brightness? overlayBrightness;

  const HomeBackgroundTheme({
    required this.id,
    required this.name,
    required this.assetPath,
    this.overlayBrightness,
  });
}

const List<HomeBackgroundTheme> homeBackgroundThemes = [
  HomeBackgroundTheme(id: 'default', name: 'Default', assetPath: ''),
  HomeBackgroundTheme(
    id: 'prism',
    name: 'Prism',
    assetPath: 'assets/images/theme_prism.jpg',
    overlayBrightness: Brightness.light, // mostly white/pale — use dark text
  ),
  HomeBackgroundTheme(
    id: 'speed',
    name: 'Speed',
    assetPath: 'assets/images/theme_speed.jpg',
    overlayBrightness: Brightness.light, // bright sky — use dark text
  ),
  HomeBackgroundTheme(
    id: 'onyx',
    name: 'Onyx',
    assetPath: 'assets/images/theme_onyx.jpg',
    overlayBrightness: Brightness.dark, // dark marble — use light text
  ),
  HomeBackgroundTheme(
    id: 'arena',
    name: 'Arena',
    assetPath: 'assets/images/theme_arena.jpg',
    overlayBrightness: Brightness.dark, // dark stadium — use light text
  ),
  HomeBackgroundTheme(
    id: 'expedition',
    name: 'Expedition',
    assetPath: 'assets/images/theme_expedition.jpg',
    overlayBrightness: Brightness.dark, // dark space — use light text
  ),
  HomeBackgroundTheme(
    id: 'universe',
    name: 'Universe',
    assetPath: 'assets/images/theme_universe.jpg',
    overlayBrightness: Brightness.dark, // dark space — use light text
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
