import 'package:flutter/material.dart';
import '../theme.dart';

import '../services/branding_service.dart';

/// Rebuilds its subtree whenever the branding lands from the backend, so a
/// screen already on-screen picks up the new logo or name without a restart.
class BrandingBuilder extends StatelessWidget {
  final WidgetBuilder builder;

  const BrandingBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: BrandingService.revision,
      builder: (context, _, __) => builder(context),
    );
  }
}

/// The vendor app's logo. Shows whatever the admin uploaded, falling back to
/// the bundled logo when nothing is set, the image fails to load, or the
/// device is offline before its first successful fetch. No branding record
/// exists today, so the bundled one is what actually shows.
class AppLogo extends StatelessWidget {
  final double size;

  /// Clips the logo into a circle to match the login screen's avatar. The
  /// splash shows it uncropped, since a wide wordmark would lose its edges.
  final bool circular;

  const AppLogo({super.key, this.size = 56, this.circular = true});

  @override
  Widget build(BuildContext context) {
    return BrandingBuilder(
      builder: (context) {
        final url = BrandingService.logoUrl;

        if (url == null || url.isEmpty) return _fallback();

        final image = Image.network(
          url,
          width: size + 32,
          height: size + 32,
          fit: circular ? BoxFit.cover : BoxFit.contain,
          errorBuilder: (_, __, ___) => _fallback(),
          frameBuilder: (context, child, frame, wasSynchronous) {
            if (wasSynchronous || frame != null) return child;
            return _fallback();
          },
        );

        return circular ? ClipOval(child: image) : image;
      },
    );
  }

  Widget _fallback() {
    final logo = Image.asset(
      'assets/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );

    // Uncropped where the caller asked for it -- the splash shows the full
    // mark. Elsewhere it sits on a tinted disc, which is what the circular
    // flag is really asking for: an avatar-shaped badge, not a cropped logo.
    if (!circular) return logo;

    return Container(
      // Tight on purpose. This mark is three interlocking shapes, and it goes
      // muddy once it is scaled down much past the size the caller asked for.
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        shape: BoxShape.circle,
      ),
      child: logo,
    );
  }
}
