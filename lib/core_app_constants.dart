class AppConstants {
  AppConstants._();

  static const String appName = 'Wigma 8';
  static const String tagline = 'Design Anything. In One Prompt.';
  static const String fromSignature = 'from PARM';

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration generationTimeout = Duration(seconds: 15);
  static const Duration exportTimeout = Duration(seconds: 5);
}

/// Design generation categories shown in the Home quick-actions grid.
enum DesignType {
  logo('Generate Logo', 'logo'),
  flyer('Generate Flyer', 'flyer'),
  poster('Create Poster', 'poster'),
  social('Social Media Design', 'social'),
  businessCard('Business Card', 'business_card'),
  banner('Banner Design', 'banner'),
  videoThumbnail('Video Thumbnail', 'video_thumbnail'),
  brandKit('Brand Kit', 'brand_kit');

  final String label;
  final String slug;
  const DesignType(this.label, this.slug);
}

enum SubscriptionPlan { free, pro, business }
