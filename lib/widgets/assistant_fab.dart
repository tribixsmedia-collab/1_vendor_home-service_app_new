import 'package:flutter/material.dart';
import '../screens/assistant_screen.dart';
import '../theme.dart';
import '../utils/breakpoints.dart';

/// The floating way in to the assistant, on the dashboard.
///
/// It lives here rather than only inside Help & Support because that is
/// several taps deep, and nobody goes looking in a support inbox for a quick
/// answer. The questions the assistant is best at -- "why am I not getting
/// jobs", "when will I be paid" -- are exactly the ones a vendor has while
/// looking at a quiet dashboard.
///
/// No sign-in gate, unlike the customer app's copy: this app has no guest
/// mode, so anything that can reach the dashboard is already signed in.
class AssistantFab extends StatelessWidget {
  const AssistantFab({super.key});

  void _open(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AssistantScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktopLayout(context)) {
      return FloatingActionButton.extended(
        onPressed: () => _open(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('Ask the assistant'),
      );
    }

    return FloatingActionButton(
      onPressed: () => _open(context),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      tooltip: 'Ask the assistant',
      child: const Icon(Icons.chat_bubble_outline),
    );
  }
}
