import 'package:equatable/equatable.dart';

/// Request payload sent to the AI generation pipeline.
class DesignRequest extends Equatable {
  final String prompt;
  final String designTypeSlug;
  final String? styleHint;
  final List<String>? colorHints;

  const DesignRequest({
    required this.prompt,
    required this.designTypeSlug,
    this.styleHint,
    this.colorHints,
  });

  @override
  List<Object?> get props => [prompt, designTypeSlug, styleHint, colorHints];
}

/// A single generated design concept (one of several returned per request).
class DesignConcept extends Equatable {
  final String id;
  final String imageUrl;
  final String styleName;
  final DateTime createdAt;

  const DesignConcept({
    required this.id,
    required this.imageUrl,
    required this.styleName,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, imageUrl, styleName, createdAt];
}

/// The full result of one generation call: several concepts to choose from.
class DesignResult extends Equatable {
  final DesignRequest request;
  final List<DesignConcept> concepts;

  const DesignResult({required this.request, required this.concepts});

  @override
  List<Object?> get props => [request, concepts];
}
