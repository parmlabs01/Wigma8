import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core_app_constants.dart';
import 'core_app_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'feature_generator_design_models.dart';
import 'feature_generator_provider.dart';

enum _AspectRatioOption {
  square('Square 1:1', Icons.crop_square_outlined),
  portrait('Portrait 3:4', Icons.crop_portrait_outlined),
  story('Story 9:16', Icons.stay_current_portrait_outlined),
  landscape('Landscape 4:3', Icons.crop_landscape_outlined),
  widescreen('Widescreen 16:9', Icons.crop_16_9_outlined);

  final String label;
  final IconData icon;
  const _AspectRatioOption(this.label, this.icon);
}

/// Prompt entry screen shared by all design types (logo, flyer, poster,
/// social, business card, banner, video thumbnail, brand kit, video
/// categories, and edit modes). The design type is passed in via the
/// `type` query param from Home.
class GeneratorInputScreen extends ConsumerStatefulWidget {
  final String designTypeSlug;
  const GeneratorInputScreen({super.key, required this.designTypeSlug});

  @override
  ConsumerState<GeneratorInputScreen> createState() => _GeneratorInputScreenState();
}

class _GeneratorInputScreenState extends ConsumerState<GeneratorInputScreen> {
  final _promptController = TextEditingController();
  _AspectRatioOption _selectedRatio = _AspectRatioOption.square;

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
      case DesignType.videoCommercials:
        return 'Create a 30-second commercial for a new sneaker launch.';
      case DesignType.videoEntertainment:
        return 'Create a short comedic sketch about a coffee shop mix-up.';
      case DesignType.videoAnimations:
        return 'Animate a 2D logo reveal with a bouncy, playful motion style.';
      case DesignType.videoCorporate:
        return 'Create a company culture video highlighting our remote team.';
      case DesignType.videoSocial:
        return 'Create a 15-second Reel announcing a weekend flash sale.';
      case DesignType.videoEducational:
        return 'Create a tutorial video explaining how compound interest works.';
      case DesignType.videoEvent:
        return 'Create a highlight reel for a wedding reception.';
      case DesignType.imageEdit:
        return 'Describe the edit — e.g. remove the background and add soft studio lighting.';
      case DesignType.videoEdit:
        return 'Describe the edit — e.g. trim to 30 seconds and add captions.';
    }
  }

  Future<void> _generate() async {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    await ref.read(generatorProvider.notifier).generate(
          DesignRequest(
            prompt: prompt,
            designTypeSlug: _type.slug,
            aspectRatio: _selectedRatio.label,
          ),
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
              // Prompt box — fixed height instead of filling the screen.
              SizedBox(
                height: 160,
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
              Text(
                'Size',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _AspectRatioOption.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final option = _AspectRatioOption.values[index];
                    final selected = option == _selectedRatio;
                    return _AspectRatioChip(
                      label: option.label,
                      icon: option.icon,
                      selected: selected,
                      onTap: () => setState(() => _selectedRatio = option),
                    );
                  },
                ),
              ),
              const Spacer(),
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

class _AspectRatioChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AspectRatioChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryNavy : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected ? AppColors.primaryNavy : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
