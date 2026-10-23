import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_gap.dart';

/// Friendly empty state (every list has one).
class TTEmptyState extends StatelessWidget {
  const TTEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.tokens.spaceXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) icon!,
            if (icon != null) const TTGap.md(),
            Text(title, style: context.text.titleMedium),
            const TTGap.sm(),
            Text(
              message,
              style: context.text.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) const TTGap.md(),
            if (actionLabel != null)
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton placeholder rows (loading state for every list).
class TTSkeletonList extends StatelessWidget {
  const TTSkeletonList({super.key, this.rows = 5});

  final int rows;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        for (var i = 0; i < rows; i++)
          Container(
            height: context.tokens.spaceXxxl,
            margin: EdgeInsets.only(bottom: context.tokens.spaceSm),
            decoration: BoxDecoration(
              color: c.surfaceContainerHighest,
              borderRadius:
                  BorderRadius.circular(context.tokens.radiusCard),
            ),
          ),
      ],
    );
  }
}

/// Single skeleton block.
class TTSkeletonBlock extends StatelessWidget {
  const TTSkeletonBlock({super.key, this.height, this.width});

  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? context.tokens.spaceXxxl,
      width: width,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(context.tokens.radiusCard),
      ),
    );
  }
}
