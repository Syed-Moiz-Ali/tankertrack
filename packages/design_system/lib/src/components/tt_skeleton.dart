import 'package:flutter/material.dart';

import '../context_ext.dart';

/// Vertical skeleton shimmer block list — see [TTSkeletonList].
class TTSkeleton extends StatelessWidget {
  const TTSkeleton({super.key, this.rows = 5});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows; i++)
          Container(
            height: context.tokens.spaceXxxl,
            margin: EdgeInsets.only(bottom: context.tokens.spaceSm),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius:
                  BorderRadius.circular(context.tokens.radiusCard),
            ),
          ),
      ],
    );
  }
}
