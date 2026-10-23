import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';

/// Today tab: time-aware greeting + honest next-up card.
///
/// Seed-agnostic on purpose: no invented assignments or vehicles.
/// P3 replaces the card body with the real day summary.
class TodayTab extends ConsumerWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final name = ref.watch(sessionProvider)?.displayName ?? '';
    return ListView(
      children: [
        const TTGap.xl(),
        Text(
          greetingFor(l10n, name, DateTime.now().hour),
          style: context.text.displaySmall,
        ),
        const TTGap.lg(),
        TTCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                AppAssets.tanker,
                semanticsLabel: l10n.today_next_up,
              ),
              const TTGap.md(),
              Text(l10n.today_next_up, style: context.text.titleLarge),
              const TTGap.xs(),
              Text(l10n.mst_empty_message, style: context.text.bodyMedium),
            ],
          ),
        ),
        const TTGap.xl(),
      ],
    );
  }

  /// Time-aware greeting, extracted for testability (hour 0-23).
  @visibleForTesting
  static String greetingFor(AppLocalizations l10n, String name, int hour) {
    if (hour < 12) return l10n.dash_greeting_morning(name);
    if (hour < 18) return l10n.dash_greeting_afternoon(name);
    return l10n.dash_greeting_evening(name);
  }
}
