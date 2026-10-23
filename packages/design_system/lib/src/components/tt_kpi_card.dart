import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_card.dart';
import 'tt_gap.dart';

/// KPI card (dashboard + control room). Numerals use tabular figures.
class TTKpiCard extends StatelessWidget {
  const TTKpiCard({
    super.key,
    required this.label,
    required this.value,
    this.sub,
    this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final String? sub;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TTCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) icon!,
              if (icon != null)
                const TTGap.sm(axis: Axis.horizontal),
              Expanded(
                child: Text(
                  label,
                  style: context.text.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const TTGap.sm(),
          Text(value, style: context.text.displaySmall),
          if (sub != null) const TTGap.xs(),
          if (sub != null)
            Text(
              sub!,
              style: context.text.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}
