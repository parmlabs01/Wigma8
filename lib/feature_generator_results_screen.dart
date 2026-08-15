import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'core_app_colors.dart';
import 'core_app_spacing.dart';
import 'feature_generator_provider.dart';

class GeneratorResultsScreen extends ConsumerWidget {
  const GeneratorResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genState = ref.watch(generatorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Concepts')),
      body: SafeArea(
        child: genState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _ErrorState(
            onRetry: () {
              final req = genState.valueOrNull?.request;
              if (req != null) ref.read(generatorProvider.notifier).generate(req);
            },
          ),
          data: (result) {
            if (result == null || result.concepts.isEmpty) {
              return const Center(child: Text('No concepts yet.'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.8,
              ),
              itemCount: result.concepts.length,
              itemBuilder: (context, index) {
                final concept = result.concepts[index];
                return _ConceptCard(
                  imageUrl: concept.imageUrl,
                  styleName: concept.styleName,
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final req = genState.valueOrNull?.request;
                    if (req != null) ref.read(generatorProvider.notifier).generate(req);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Download'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConceptCard extends StatelessWidget {
  final String imageUrl;
  final String styleName;

  const _ConceptCard({required this.imageUrl, required this.styleName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: imageUrl.isEmpty
                ? Container(
                    color: AppColors.surfaceMuted,
                    child: const Icon(Icons.image_outlined,
                        color: AppColors.textSecondary, size: 32),
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (_, __) => Container(color: AppColors.surfaceMuted),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.surfaceMuted,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm,
              horizontal: AppSpacing.sm,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(styleName, style: Theme.of(context).textTheme.bodyMedium),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () {},
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: const Icon(Icons.ios_share, size: 18),
                      onPressed: () {},
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, size: 18),
                      onPressed: () {},
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
            const SizedBox(height: AppSpacing.md),
            const Text('Generation failed. Please try again.'),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
