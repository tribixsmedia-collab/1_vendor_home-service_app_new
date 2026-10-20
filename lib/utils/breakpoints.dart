import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

/// Width at which the web build stops being a phone layout stretched wide.
///
/// Below this - every phone, and a narrow browser window - nothing changes,
/// so the installed Android and iOS apps are untouched. The customer app uses
/// the same number, so the two sites break at the same point.
const double kDesktopBreakpoint = 900;

/// Content column width on desktop. Narrower than the customer site's 1240:
/// this is a working dashboard of cards rather than a storefront grid, and
/// past about this width the stat row drifts away from the heading above it.
const double kDesktopContentWidth = 1100;

bool isDesktopLayout(BuildContext context) =>
    kIsWeb && MediaQuery.sizeOf(context).width >= kDesktopBreakpoint;

/// Centres [child] in the desktop content column. A no-op on narrow screens,
/// so the same widget tree serves both layouts.
class DesktopCentered extends StatelessWidget {
  const DesktopCentered({
    super.key,
    required this.child,
    this.maxWidth = kDesktopContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    if (!isDesktopLayout(context)) return child;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
