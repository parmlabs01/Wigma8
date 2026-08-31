import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageProvider = StateProvider<String>((ref) => 'English');
final personalizationStyleProvider = StateProvider<String>((ref) => 'Balanced');
final contentFiltersEnabledProvider = StateProvider<bool>((ref) => true);
final accentColorProvider = StateProvider<Color>((ref) => const Color(0xFF3B82F6));
final emailNotificationsProvider = StateProvider<bool>((ref) => true);
final pushNotificationsProvider = StateProvider<bool>((ref) => true);
final defaultExportFormatProvider = StateProvider<String>((ref) => 'PNG');
final hdExportEnabledProvider = StateProvider<bool>((ref) => false);
final dataControlsEnabledProvider = StateProvider<bool>((ref) => true);
