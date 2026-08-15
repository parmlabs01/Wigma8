import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_constants.dart';
import 'core_app_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'feature_generator_design_models.dart';
import 'feature_generator_provider.dart';

/// Prompt entry screen shared by all design types (logo, flyer, poster,
/// social, business card, banner, video thumbnail, brand kit). The
/// design type is passed in via the `type` query param from Home.
class GeneratorInputScreen extends ConsumerStatefulWidget {
  final String designTypeSlug;
  const GeneratorInputScreen({super.key, required this.designTypeSlug});

  @override
  ConsumerState<GeneratorInputScreen> createState() => _GeneratorInputScreenState();
}

class _GeneratorInputScreenState extends ConsumerState<GeneratorInputScreen> {
  final _promptController = TextEditingController();

  DesignType get _type => DesignType.values.firstWhere(
        (t) => t.slug == widget.designTypeSlug,
        orElse: () => DesignType.logo,
      );

  String get _placeholder {
    switch (_type) {
      case DesignType.logo:
        return 'Create a luxury real estate logo called Bikorn Properties using navy and gold.';
      case DesignType.flyer:
        return 'Design a church flyer for a revival program.';
      case DesignType.poster:
        return 'Design a poster for a summer music festival.';
      case DesignType.social:
        return 'Create an Instagram post announcing a product launch.';
      case DesignType.businessCard:
        return 'Design a minimalist business card for a photographer.';
      case DesignType.banner:
        return 'Design a web banner for a Black Friday sale.';
      case DesignType.videoThumbnail:
        return 'Create a bold YouTube thumbnail for a tech review video.';
      case DesignType.brandKit:
        return 'Build a brand kit for a coffee roastery called Ember & Oak.';
    }
  }

  Future<void> _generate() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    await ref.read(generatorProvider.notifier).generate(
          DesignRequest(prompt: prompt, designTypeSlug: _type.slug),
        );

    if (mounted) context.push(AppRoutes.generatorResults);
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final genState = ref.watch(generatorProvider);
    final loading = genState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(_type.label)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Describe your ${_type.label.toLowerCase()}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Be specific — mention names, colors, and mood for the best result.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: TextField(
                  controller: _promptController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: _placeholder,
                    hintMaxLines: 4,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: loading ? null : _generate,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_awesome, size: 20),
                  label: Text(loading ? 'Generating…' : 'Generate with AI'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
