import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:l10n/l10n.dart';

/// Messages tab: illustrated empty state. P5 wires dispatch messages here.
class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TTEmptyState(
      title: l10n.mst_empty_title,
      message: l10n.mst_empty_message,
      icon: SvgPicture.asset(
        AppAssets.emptyMap,
        semanticsLabel: l10n.mst_empty_title,
      ),
    );
  }
}
