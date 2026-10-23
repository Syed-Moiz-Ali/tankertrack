import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';

/// One command-palette entry: localized title + optional subtitle + icon.
///
/// Selection is reported via [TTCommandPalette.onSelect] — entries carry no
/// callbacks so the palette can filter and rank them freely.
@immutable
class TTCommandItem {
  const TTCommandItem({required this.title, this.subtitle, this.icon});

  final String title;
  final String? subtitle;
  final AppIcon? icon;
}

/// Command palette (R3 §5): compact search over orders/trips/drivers/
/// vehicles/customers, filter list + keyboard shortcut hint footer.
///
/// All strings arrive via params (host passes `context.l10n` values).
/// Use [showTTCommandPalette] to present it as a dialog.
class TTCommandPalette extends StatefulWidget {
  const TTCommandPalette({
    super.key,
    required this.hint,
    required this.items,
    required this.noResults,
    required this.shortcutHint,
    required this.onSelect,
    this.initialQuery = '',
  });

  final String hint;
  final List<TTCommandItem> items;
  final String noResults;
  final String shortcutHint;
  final ValueChanged<TTCommandItem> onSelect;
  final String initialQuery;

  @override
  State<TTCommandPalette> createState() => _TTCommandPaletteState();
}

class _TTCommandPaletteState extends State<TTCommandPalette> {
  late final TextEditingController _controller;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<TTCommandItem> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items.where((item) {
      final hay = '${item.title} ${item.subtitle ?? ''}'.toLowerCase();
      return hay.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    final results = _filtered;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextField(
          controller: _controller,
          autofocus: true,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: Icon(
              AppIcons.iconFor(AppIcons.search, context),
            ),
          ),
        ),
        const TTGap.md(),
        Flexible(
          child: results.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(t.spaceLg),
                  child: Text(
                    widget.noResults,
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const TTGap.xs(),
                  itemBuilder: (context, i) => _TTCommandRow(
                    item: results[i],
                    onTap: () => widget.onSelect(results[i]),
                  ),
                ),
        ),
        const TTGap.sm(),
        const Divider(),
        const TTGap.xs(),
        Text(
          widget.shortcutHint,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _TTCommandRow extends StatefulWidget {
  const _TTCommandRow({required this.item, required this.onTap});

  final TTCommandItem item;
  final VoidCallback onTap;

  @override
  State<_TTCommandRow> createState() => _TTCommandRowState();
}

class _TTCommandRowState extends State<_TTCommandRow> {
  bool _hover = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    final highlight = _hover || _focused;
    return Semantics(
      button: true,
      child: Focus(
        onFocusChange: (v) => setState(() => _focused = v),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: widget.onTap,
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: t.motionMicro,
              curve: t.curve,
              padding: EdgeInsets.symmetric(
                horizontal: t.spaceLg,
                vertical: t.spaceSm,
              ),
              decoration: BoxDecoration(
                color: highlight ? c.surfaceContainerHighest : null,
                borderRadius: BorderRadius.circular(t.radiusCard),
                border: Border.all(
                  color: _focused ? c.primary : c.outlineVariant,
                ),
              ),
              child: Row(
                children: <Widget>[
                  if (widget.item.icon != null) ...<Widget>[
                    Icon(
                      AppIcons.iconFor(widget.item.icon!, context),
                      color: c.onSurfaceVariant,
                      size: t.iconMd,
                    ),
                    const TTGap.md(axis: Axis.horizontal),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(widget.item.title, style: context.text.titleSmall),
                        if (widget.item.subtitle != null)
                          Text(
                            widget.item.subtitle!,
                            style: context.text.bodySmall?.copyWith(
                              color: c.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    AppIcons.iconFor(AppIcons.forward, context),
                    color: c.onSurfaceVariant,
                    size: t.iconSm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Presents a [TTCommandPalette] as a centered dialog.
///
/// Returns the selected entry, or null when dismissed.
Future<TTCommandItem?> showTTCommandPalette(
  BuildContext context, {
  required String hint,
  required List<TTCommandItem> items,
  required String noResults,
  required String shortcutHint,
}) {
  return showDialog<TTCommandItem>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      content: SizedBox(
        width: dialogContext.tokens.contentNarrow,
        child: TTCommandPalette(
          hint: hint,
          items: items,
          noResults: noResults,
          shortcutHint: shortcutHint,
          onSelect: (item) => Navigator.of(dialogContext).pop(item),
        ),
      ),
    ),
  );
}
