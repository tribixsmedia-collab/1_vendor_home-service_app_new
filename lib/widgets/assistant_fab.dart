import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import '../screens/assistant_screen.dart';
import '../utils/breakpoints.dart';

/// The floating way in to the assistant, on the dashboard.
///
/// It lives here rather than only inside Help & Support because that is
/// several taps deep, and nobody goes looking in a support inbox for a quick
/// answer. The questions this assistant is best at -- "why am I not getting
/// jobs", "when will I be paid" -- are exactly the ones a vendor has while
/// looking at a quiet dashboard.
///
/// A robot rather than a labelled pill: it reads as "chat" to anyone who has
/// used the web, in any language, which matters on a site whose vendors do
/// not all read English comfortably.
///
/// No sign-in gate, unlike the customer app's copy: this app has no guest
/// mode, so anything that can reach the dashboard is already signed in.
class AssistantFab extends StatefulWidget {
  const AssistantFab({super.key});

  @override
  State<AssistantFab> createState() => _AssistantFabState();
}

class _AssistantFabState extends State<AssistantFab>
    with SingleTickerProviderStateMixin {
  /// A slow bob, so the mascot reads as floating rather than stuck on.
  ///
  /// Four seconds and six pixels: enough to catch the eye once, slow enough
  /// not to nag at somebody trying to read the page behind it.
  late final AnimationController _bob = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  void _open() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AssistantScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = isDesktopLayout(context) ? 110.0 : 88.0;

    // The bob wraps the tap target rather than sitting inside it, so what you
    // see is what you can tap. The other way round, the mascot drifts up to
    // six pixels away from its own hit box -- the kind of near-miss nobody
    // can describe but everybody feels.
    return AnimatedBuilder(
      animation: _bob,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -6 * Curves.easeInOut.transform(_bob.value)),
        child: child,
      ),
      child: Tooltip(
        message: 'Ask the assistant',
        child: GestureDetector(
          onTap: _open,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              fit: StackFit.expand,
              children: [_shadow(), _mascot()],
            ),
          ),
        ),
      ),
    );
  }

  /// A drop shadow that follows the robot's own outline rather than a disc
  /// behind it.
  ///
  /// The mascot is mostly white and so is the page, so without this it
  /// dissolves into the background -- and a circular shadow would show as a
  /// halo around a shape that is not a circle.
  Widget _shadow() {
    return Transform.translate(
      offset: const Offset(0, 5),
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: _mascot(
          color: Colors.black.withValues(alpha: 0.3),
          blend: BlendMode.srcIn,
        ),
      ),
    );
  }

  /// The mascot, optionally flattened to a silhouette for the shadow pass.
  Widget _mascot({Color? color, BlendMode? blend}) {
    return Image.asset(
      'assets/assistant_bot.png',
      fit: BoxFit.contain,
      color: color,
      colorBlendMode: blend,
      // A missing asset must not take the whole shell down with it.
      errorBuilder: (context, error, stack) => const Center(
        child: CircleAvatar(child: Icon(Icons.chat_bubble_outline)),
      ),
    );
  }
}
