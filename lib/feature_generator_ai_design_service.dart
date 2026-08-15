import 'package:dio/dio.dart';

import 'core_env.dart';
import 'feature_generator_design_models.dart';

/// Abstraction over whichever AI image/design backend is generating the
/// concepts for a request. The PRD lists OpenAI, Gemini, Stability AI,
/// and Flux as candidate providers — concrete implementations below
/// each wrap one provider's API. Swap `defaultAiDesignService` to
/// change which one Wigma 8 uses by default, or implement routing logic
/// (e.g. logos -> Stability, flyers -> Flux) in a composite service.
abstract class AiDesignService {
  Future<DesignResult> generate(DesignRequest request);
}

/// Stability AI (stable-diffusion / SD3) implementation.
class StabilityDesignService implements AiDesignService {
  final Dio _dio;
  StabilityDesignService({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<DesignResult> generate(DesignRequest request) async {
    // POST https://api.stability.ai/v2beta/stable-image/generate/sd3
    // Multipart form with `prompt`, `output_format`, etc.
    // Response returns base64/binary image bytes per concept.
    final response = await _dio.post(
      'https://api.stability.ai/v2beta/stable-image/generate/sd3',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${Env.stabilityApiKey}',
          'Accept': 'application/json',
        },
      ),
      data: FormData.fromMap({
        'prompt': _composePrompt(request),
        'output_format': 'png',
      }),
    );

    final images = (response.data['artifacts'] as List? ?? []);
    return DesignResult(
      request: request,
      concepts: [
        for (var i = 0; i < images.length; i++)
          DesignConcept(
            id: 'stability-$i-${DateTime.now().millisecondsSinceEpoch}',
            imageUrl: images[i]['url'] ?? '',
            styleName: 'Concept ${i + 1}',
            createdAt: DateTime.now(),
          ),
      ],
    );
  }

  String _composePrompt(DesignRequest r) {
    final style = r.styleHint != null ? ', style: ${r.styleHint}' : '';
    final colors = (r.colorHints?.isNotEmpty ?? false)
        ? ', colors: ${r.colorHints!.join(', ')}'
        : '';
    return '${r.designTypeSlug} design: ${r.prompt}$style$colors, premium, professional, high resolution';
  }
}

/// OpenAI (gpt-image-1 / DALL·E) implementation.
class OpenAiDesignService implements AiDesignService {
  final Dio _dio;
  OpenAiDesignService({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<DesignResult> generate(DesignRequest request) async {
    final response = await _dio.post(
      'https://api.openai.com/v1/images/generations',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${Env.openAiApiKey}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'model': 'gpt-image-1',
        'prompt': '${request.designTypeSlug}: ${request.prompt}',
        'n': 4,
        'size': '1024x1024',
      },
    );

    final data = (response.data['data'] as List? ?? []);
    return DesignResult(
      request: request,
      concepts: [
        for (var i = 0; i < data.length; i++)
          DesignConcept(
            id: 'openai-$i-${DateTime.now().millisecondsSinceEpoch}',
            imageUrl: data[i]['url'] ?? '',
            styleName: 'Concept ${i + 1}',
            createdAt: DateTime.now(),
          ),
      ],
    );
  }
}

/// Default provider used across the app. Change this line to switch
/// providers globally, or replace with a composite/router service.
AiDesignService defaultAiDesignService = StabilityDesignService();
