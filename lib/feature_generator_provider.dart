import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature_generator_ai_design_service.dart';
import 'feature_generator_design_models.dart';

final aiDesignServiceProvider = Provider<AiDesignService>((ref) {
  return defaultAiDesignService;
});

/// Holds the async state of the most recent generation request so the
/// results screen can watch it and react to loading / data / error.
class GeneratorNotifier extends AsyncNotifier<DesignResult?> {
  @override
  Future<DesignResult?> build() async => null;

  Future<void> generate(DesignRequest request) async {
    state = const AsyncLoading();
    final service = ref.read(aiDesignServiceProvider);
    state = await AsyncValue.guard(() => service.generate(request));
  }

  void reset() {
    state = const AsyncData(null);
  }
}

final generatorProvider =
    AsyncNotifierProvider<GeneratorNotifier, DesignResult?>(GeneratorNotifier.new);
