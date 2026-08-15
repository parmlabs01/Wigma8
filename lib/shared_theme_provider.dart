import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple in-memory theme mode toggle. Persist via shared_preferences
/// if the choice should survive app restarts.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);
