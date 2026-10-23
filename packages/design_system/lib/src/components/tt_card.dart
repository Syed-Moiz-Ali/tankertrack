import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_gap.dart';

/// Rounded bordered card (12px radius, soft border, resting elevation 0).
class TTCard extends StatelessWidget {
  const TTCard({super.key, required this.child, this.onTap, this.padding});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final body = Padding(
      padding: padding ?? EdgeInsets.all(t.spaceLg),
      child: child,
    );
    final card = Card(child: body);
    if (onTap == null) return card;
    return InkWell(
      borderRadius: BorderRadius.circular(t.radiusCard),
      onTap: onTap,
      child: card,
    );
  }
}

/// Page section: title row + content with token spacing.
class TTSection extends StatelessWidget {
  const TTSection({
    super.key,
    required this.title,
    required this.child,
    this.action,
  });

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title, style: context.text.titleLarge),
            ),
            if (action != null) action!,
          ],
        ),
        const TTGap.md(),
        child,
      ],
    );
  }
}

/// Theme-styled list tile (56px rows via DataTable/ListTile themes).
class TTListTile extends StatelessWidget {
  const TTListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// Avatar with initials (colors from scheme; no literals).
class TTAvatar extends StatelessWidget {
  const TTAvatar({super.key, required this.initials, this.small = false});

  final String initials;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return CircleAvatar(
      backgroundColor: c.primaryContainer,
      foregroundColor: c.onPrimaryContainer,
      radius: small ? context.tokens.iconMd : context.tokens.iconLg,
      child: Text(initials, style: context.text.titleSmall),
    );
  }
}
