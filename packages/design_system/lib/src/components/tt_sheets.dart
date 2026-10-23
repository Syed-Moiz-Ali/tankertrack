import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_gap.dart';

/// Grabber sheet content wrapper: top grabber handle + [child].
/// Sheet chrome (background, drag handle) comes from the BottomSheetTheme.
class TTGrabberSheet extends StatelessWidget {
  const TTGrabberSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(t.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: t.spaceXxxl,
                height: t.spaceXs,
                decoration: BoxDecoration(
                  color: context.colors.outline,
                  borderRadius: BorderRadius.circular(t.radiusPill),
                ),
              ),
            ),
            const TTGap.md(),
            child,
          ],
        ),
      ),
    );
  }
}

/// Shows [child] in a themed modal grabber sheet (scroll-controlled so the
/// sheet sizes to tall content like the profile menu).
Future<T?> showTTGrabberSheet<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (_) => SingleChildScrollView(
      child: TTGrabberSheet(child: child),
    ),
  );
}
