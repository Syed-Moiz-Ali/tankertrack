import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';

/// Page chrome: safe area, responsive gutters + max-width, optional app bar
/// and banner slot (offline / tracking-active / stale banners render here).
class TTScaffold extends StatelessWidget {
  const TTScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.banner,
    this.bottomBar,
    this.floatingActionButton,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? banner;
  final Widget? bottomBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final width = MediaQuery.widthOf(context);
    final gutter = width < t.breakpointMobile
        ? t.gutterMobile
        : width < t.breakpointTablet
            ? t.gutterTablet
            : t.gutterDesktop;
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomBar,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (banner != null) banner!,
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: t.maxContentWidth),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: gutter),
                    child: body,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standard app bar (look from AppBarTheme).
class TTAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TTAppBar({super.key, required this.title, this.actions, this.leading});

  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title), actions: actions, leading: leading);
  }
}

/// Alert banner variants (color from scheme/status; icon from AppIcons).
enum TTBannerKind { info, warning, critical, offline, tracking }

class TTBanner extends StatelessWidget {
  const TTBanner({
    super.key,
    required this.message,
    this.kind = TTBannerKind.info,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final TTBannerKind kind;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final s = context.status;
    final (bg, fg, icon) = switch (kind) {
      TTBannerKind.info => (c.primaryContainer, c.onPrimaryContainer, AppIcons.info),
      TTBannerKind.warning =>
        (s.waitingBg, s.waiting, AppIcons.incident),
      TTBannerKind.critical => (s.criticalBg, s.critical, AppIcons.breakdown),
      TTBannerKind.offline => (s.offlineBg, s.offline, AppIcons.offline),
      TTBannerKind.tracking => (s.activeBg, s.active, AppIcons.tracking),
    };
    return Container(
      width: double.infinity,
      color: bg,
      padding: EdgeInsets.symmetric(
        horizontal: context.tokens.spaceLg,
        vertical: context.tokens.spaceSm,
      ),
      child: Row(
        children: [
          Icon(AppIcons.iconFor(icon, context), color: fg, size: context.tokens.iconMd),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.tokens.spaceSm),
              child: Text(
                message,
                style: context.text.bodyMedium?.copyWith(color: fg),
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}
