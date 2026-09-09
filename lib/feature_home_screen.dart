import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'core_app_constants.dart';
import 'core_app_router.dart';
import 'core_app_colors.dart';
import 'core_app_spacing.dart';

enum _HomeMode { image, video }
enum _HomeSubTab { create, edit }

class _Category {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? coverImage;
  final String routeType;

  const _Category({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeType,
    this.coverImage,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _HomeMode _mode = _HomeMode.image;
  _HomeSubTab _subTab = _HomeSubTab.create;
  bool _forward = true;

  // ---- Image / Create (your existing cover cards) ----
  static const _imageCreateRaw =
      <(DesignType, IconData, String, String)>[
    (DesignType.logo, Icons.auto_awesome_outlined, 'Brand marks & wordmarks',
        'assets/images/cover_logo.jpg'),
    (DesignType.flyer, Icons.image_outlined, 'Posters & promos',
        'assets/images/cover_flyer.jpg'),
    (DesignType.poster, Icons.videocam_outlined, 'Key frames & covers',
        'assets/images/cover_poster.jpg'),
    (DesignType.social, Icons.content_cut_outlined, 'Re-style a frame',
        'assets/images/cover_social.jpg'),
    (DesignType.businessCard, Icons.badge_outlined, 'Contact-ready cards',
        'assets/images/cover_business_card.jpg'),
    (DesignType.banner, Icons.panorama_outlined, 'Wide-format banners',
        'assets/images/cover_banner.jpg'),
    (DesignType.videoThumbnail, Icons.video_camera_back_outlined,
        'Eye-catching thumbnails', 'assets/images/cover_video_thumbnail.jpg'),
    (DesignType.brandKit, Icons.palette_outlined, 'Full brand system',
        'assets/images/cover_brand_kit.jpg'),
  ];

  List<_Category> get _imageCreate => _imageCreateRaw
      .map((e) => _Category(
            title: e.$1.label,
            subtitle: e.$3,
            icon: e.$2,
            coverImage: e.$4,
            routeType: e.$1.slug,
          ))
      .toList();

  // ---- Video / Create (your categories) ----
  static const _videoCreate = <_Category>[
    _Category(
      title: 'Commercials',
      subtitle: 'Ads & promos',
      icon: Icons.campaign_outlined,
      routeType: 'video-commercials',
      coverImage: 'assets/images/cover_video_commercials.jpg',
    ),
    _Category(
      title: 'Entertainment',
      subtitle: 'Shows & shorts',
      icon: Icons.theater_comedy_outlined,
      routeType: 'video-entertainment',
      coverImage: 'assets/images/cover_video_entertainment.jpg',
    ),
    _Category(
      title: 'Animations',
      subtitle: 'Motion & 2D/3D',
      icon: Icons.animation_outlined,
      routeType: 'video-animations',
      coverImage: 'assets/images/cover_video_animations.jpg',
    ),
    _Category(
      title: 'Corporate',
      subtitle: 'Internal & brand videos',
      icon: Icons.business_center_outlined,
      routeType: 'video-corporate',
      coverImage: 'assets/images/cover_video_corporate.jpg',
    ),
    _Category(
      title: 'Social Media',
      subtitle: 'Reels & posts',
      icon: Icons.dynamic_feed_outlined,
      routeType: 'video-social',
      coverImage: 'assets/images/cover_video_social.jpg',
    ),
    _Category(
      title: 'Educational',
      subtitle: 'Tutorials & courses',
      icon: Icons.school_outlined,
      routeType: 'video-educational',
      coverImage: 'assets/images/cover_video_educational.jpg',
    ),
    _Category(
      title: 'Event',
      subtitle: 'Highlights & recaps',
      icon: Icons.event_outlined,
      routeType: 'video-event',
      coverImage: 'assets/images/cover_video_event.jpg',
    ),
  ];

  void _setMode(_HomeMode mode) {
    if (mode == _mode) return;
    setState(() {
      _forward = mode == _HomeMode.video;
      _mode = mode;
    });
  }

  void _setSubTab(_HomeSubTab subTab) {
    if (subTab == _subTab) return;
    setState(() {
      _forward = subTab == _HomeSubTab.edit;
      _subTab = subTab;
    });
  }

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity;
    if (velocity == null) return;
    if (velocity < -200 && _mode == _HomeMode.image) {
      _setMode(_HomeMode.video);
    } else if (velocity > 200 && _mode == _HomeMode.video) {
      _setMode(_HomeMode.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
                ),
                child: _Hero(context: context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
                ),
                child: _ModeToggle(mode: _mode, onChanged: _setMode),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 0,
                ),
                child: _SubTabBar(subTab: _subTab, onChanged: _setSubTab),
              ),
              const SizedBox(height: AppSpacing.md),
              GestureDetector(
                onHorizontalDragEnd: _handleSwipe,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      final offsetAnimation = Tween<Offset>(
                        begin: Offset(_forward ? 1 : -1, 0),
                        end: Offset.zero,
                      ).animate(animation);
                      return SlideTransition(position: offsetAnimation, child: child);
                    },
                    child: _subTab == _HomeSubTab.create
                        ? _CategoryGrid(
                            key: ValueKey('create-$_mode'),
                            categories: _mode == _HomeMode.image
                                ? _imageCreate
                                : _videoCreate,
                            onSelect: (c) => context.push(
                              '${AppRoutes.generatorInput}?type=${c.routeType}',
                            ),
                          )
                        : _EditPanel(
                            key: ValueKey('edit-$_mode'),
                            mode: _mode,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg, 0,
                ),
                child: _DraftsSection(context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final _HomeMode mode;
  final ValueChanged<_HomeMode> onChanged;

  const _ModeToggle({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeSegment(
              label: 'Image',
              selected: mode == _HomeMode.image,
              onTap: () => onChanged(_HomeMode.image),
            ),
          ),
          Expanded(
            child: _ModeSegment(
              label: 'Video',
              selected: mode == _HomeMode.video,
              onTap: () => onChanged(_HomeMode.video),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryNavy : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _SubTabBar extends StatelessWidget {
  final _HomeSubTab subTab;
  final ValueChanged<_HomeSubTab> onChanged;

  const _SubTabBar({required this.subTab, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SubTabItem(
          label: 'Create',
          selected: subTab == _HomeSubTab.create,
          onTap: () => onChanged(_HomeSubTab.create),
        ),
        const SizedBox(width: AppSpacing.lg),
        _SubTabItem(
          label: 'Edit',
          selected: subTab == _HomeSubTab.edit,
          onTap: () => onChanged(_HomeSubTab.edit),
        ),
      ],
    );
  }
}

class _SubTabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SubTabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              color: selected ? AppColors.primaryNavy : AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: 28,
            color: selected ? AppColors.primaryNavy : Colors.transparent,
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.push(AppRoutes.activity),
            icon: const _MenuIcon(),
            tooltip: 'Previous activity',
          ),
          Row(
            children: [
              Image.asset(
                'assets/images/wigma8_logo.png',
                height: 24,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => context.push(AppRoutes.upgrade),
            icon: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.primaryNavy,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.workspace_premium_outlined,
                  color: Colors.white, size: 18),
            ),
            tooltip: 'Upgrade',
          ),
        ],
      ),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  const _MenuIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        color: AppColors.primaryNavy,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 16,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 16,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final BuildContext context;
  const _Hero({required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                ),
            children: [
              const TextSpan(text: 'Design anything,\n'),
              TextSpan(
                text: 'in one prompt.',
                style: TextStyle(color: AppColors.accent),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Pick a canvas and describe your project. Wigma 8 handles the rest.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------
// EDIT MODE — prompt box + upload, replaces the category grid entirely
// ---------------------------------------------------------------------
class _EditPanel extends StatefulWidget {
  final _HomeMode mode;
  const _EditPanel({super.key, required this.mode});

  @override
  State<_EditPanel> createState() => _EditPanelState();
}

class _EditPanelState extends State<_EditPanel> {
  final _promptController = TextEditingController();
  final _picker = ImagePicker();
  XFile? _pickedFile;
  Uint8List? _previewBytes;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  bool get _isVideo => widget.mode == _HomeMode.video;

  Future<void> _pickFile() async {
    try {
      final XFile? file = _isVideo
          ? await _picker.pickVideo(source: ImageSource.gallery)
          : await _picker.pickImage(source: ImageSource.gallery);

      if (file == null) return; // user cancelled

      Uint8List? bytes;
      if (!_isVideo) {
        bytes = await file.readAsBytes();
      }

      if (!mounted) return;
      setState(() {
        _pickedFile = file;
        _previewBytes = bytes;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open picker: $e')),
      );
    }
  }

  void _generate() {
    final type = _isVideo ? 'video-edit' : 'image-edit';
    context.push(
      '${AppRoutes.generatorInput}?type=$type&prompt=${Uri.encodeComponent(_promptController.text)}',
    );
    // NOTE: _pickedFile currently isn't forwarded to the generator route —
    // once you're ready to send it to your backend, read its bytes with
    // `await _pickedFile!.readAsBytes()` (or pass the XFile itself if the
    // next screen can accept it) and attach it to your DesignRequest.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: _pickFile,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: DottedUploadBox(
            icon: _isVideo ? Icons.videocam_outlined : Icons.image_outlined,
            label: _pickedFile?.name ?? (_isVideo ? 'Upload Video' : 'Upload Image'),
            hasFile: _pickedFile != null,
            previewBytes: _previewBytes,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _promptController,
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: _isVideo
                ? 'Describe the edit you want — trim, captions, color grade…'
                : 'Describe the edit you want — background, retouch, style…',
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              borderSide: BorderSide(color: AppColors.border),
            ),
            contentPadding: const EdgeInsets.all(AppSpacing.md),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ElevatedButton(
          onPressed: _generate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryNavy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
          child: const Text('Generate'),
        ),
      ],
    );
  }
}

class DottedUploadBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool hasFile;
  final Uint8List? previewBytes;

  const DottedUploadBox({
    super.key,
    required this.icon,
    required this.label,
    required this.hasFile,
    this.previewBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: hasFile ? AppColors.primaryNavy : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          if (previewBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: Image.memory(
                previewBytes!,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            )
          else
            Icon(icon, color: AppColors.primaryNavy, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: hasFile ? AppColors.primaryNavy : AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final List<_Category> categories;
  final ValueChanged<_Category> onSelect;

  const _CategoryGrid({
    super.key,
    required this.categories,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.95,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final c = categories[index];
        return c.coverImage != null
            ? _CoverActionCard(
                title: c.title,
                subtitle: c.subtitle,
                icon: c.icon,
                coverImage: c.coverImage!,
                onTap: () => onSelect(c),
              )
            : _PlainActionCard(
                title: c.title,
                subtitle: c.subtitle,
                icon: c.icon,
                onTap: () => onSelect(c),
              );
      },
    );
  }
}

class _CoverActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String coverImage;
  final VoidCallback onTap;

  const _CoverActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.coverImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              coverImage,
              fit: BoxFit.cover,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.05),
                    Colors.black.withOpacity(0.65),
                  ],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryNavy,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              letterSpacing: 0.3,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withOpacity(0.85),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlainActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _PlainActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryNavy.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primaryNavy,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DraftsSection extends StatelessWidget {
  final BuildContext context;
  const _DraftsSection({required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Drafts', style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              onPressed: () => context.push(AppRoutes.drafts),
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              const Icon(Icons.folder_outlined,
                  color: AppColors.textSecondary, size: 32),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No drafts yet — your recent generations will appear here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push(
              '${AppRoutes.generatorInput}?type=logo',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNavy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            child: const Text('Start Designing'),
          ),
        ),
      ],
    );
  }
}
