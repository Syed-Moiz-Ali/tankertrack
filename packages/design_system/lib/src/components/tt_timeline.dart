import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_gap.dart';

/// Event timeline (trip detail). Direction-aware:
/// CrossAxisAlignment.start + Directionality — no left/right literals.
class TTTimeline extends StatelessWidget {
  const TTTimeline({super.key, required this.entries});

  final List<TTTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < entries.length; i++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: context.tokens.spaceMd,
                    height: context.tokens.spaceMd,
                    decoration: BoxDecoration(
                      color: entries[i].color ?? context.colors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (i < entries.length - 1)
                    Container(
                      width: context.tokens.spaceXs / 2,
                      height: context.tokens.spaceXl,
                      color: context.colors.outlineVariant,
                    ),
                ],
              ),
              const TTGap.sm(axis: Axis.horizontal),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: context.tokens.spaceMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entries[i].title, style: context.text.titleSmall),
                      if (entries[i].subtitle != null)
                        Text(
                          entries[i].subtitle!,
                          style: context.text.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class TTTimelineEntry {
  const TTTimelineEntry({required this.title, this.subtitle, this.color});
  final String title;
  final String? subtitle;
  final Color? color;
}
