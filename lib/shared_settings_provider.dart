import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageProvider = StateProvider<String>((ref) => 'English');
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);
