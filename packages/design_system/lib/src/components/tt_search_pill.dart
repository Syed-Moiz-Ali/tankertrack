import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';
import 'tt_gap.dart';

/// One search segment: small semibold label over a grey value (R1).
@immutable
class TTSearchSegment {
  const TTSearchSegment({required this.label, required this.value});

  final String label;
  final String value;
}

/// Airbnb-style search pill (R1): rounded-full surface pill, soft float
/// shadow, hairline dividers between segments, circular accent search button.
///
/// [compact] renders the single-line variant (R2): segment values inline
/// with dividers plus a small accent button. [onTapSegment] receives the
/// tapped segment index; [searchLabel] names the search action for
/// tooltip/semantics.
class TTSearchPill extends StatelessWidget {
  const TTSearchPill({
    super.key,
    required this.segments,
    this.onTapSegment,
    this.onSearch,
    this.searchLabel,
    this.compact = false,
  });

  /// 09 reference width (~850px max).
  static const double maxWidth = 850;

  final List<TTSearchSegment> segments;
  final ValueChanged<int>? onTapSegment;
  final VoidCallback? onSearch;
  final String? searchLabel;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(t.radiusPill),
            border: Border.all(color: c.outlineVariant),
            boxShadow: <BoxShadow>[context.shadows.float],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: t.spaceLg,
            vertical: compact ? t.spaceSm : t.spaceMd,
          ),
          child: Row(
            children: <Widget>[
              Expanded(child: compact ? _compactValues() : _segmentRow()),
              const TTGap.md(axis: Axis.horizontal),
              _TTSearchButton(
                compact: compact,
                onSearch: onSearch,
                searchLabel: searchLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _segmentRow() {
    return Row(
      children: <Widget>[
        for (var i = 0; i < segments.length; i++) ...<Widget>[
          Expanded(
            child: _TTSearchSegmentButton(
              index: i,
              segment: segments[i],
              onTap: onTapSegment,
            ),
          ),
          if (i < segments.length - 1) const _TTSegmentDivider(tall: true),
        ],
      ],
    );
  }

  Widget _compactValues() {
    return Row(
      children: <Widget>[
        for (var i = 0; i < segments.length; i++) ...<Widget>[
          Flexible(
            child: _TTCompactValue(index: i, segment: segments[i]),
          ),
          if (i < segments.length - 1) const _TTSegmentDivider(tall: false),
        ],
      ],
    );
  }
}

class _TTSearchSegmentButton extends StatelessWidget {
  const _TTSearchSegmentButton({
    required this.index,
    required this.segment,
    required this.onTap,
  });

  final int index;
  final TTSearchSegment segment;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    return InkWell(
      borderRadius: BorderRadius.circular(t.radiusPill),
      onTap: onTap == null ? null : () => onTap!(index),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: t.spaceLg,
          vertical: t.spaceXs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              segment.label,
              style: context.text.labelMedium?.copyWith(
                color: c.onSurface,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              segment.value,
              style: context.text.bodyMedium?.copyWith(
                color: c.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _TTCompactValue extends StatelessWidget {
  const _TTCompactValue({required this.index, required this.segment});

  final int index;
  final TTSearchSegment segment;

  @override
  Widget build(BuildContext context) {
    return Text(
      segment.value,
      style: context.text.titleSmall,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TTSegmentDivider extends StatelessWidget {
  const _TTSegmentDivider({required this.tall});

  final bool tall;

  @override
  Widget build(BuildContext context) {
    final t = context.tokens;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spaceSm),
      child: Container(
        width: 1,
        height: tall ? t.spaceXxxl : t.spaceXl,
        color: context.colors.outlineVariant,
      ),
    );
  }
}

class _TTSearchButton extends StatelessWidget {
  const _TTSearchButton({
    required this.compact,
    required this.onSearch,
    required this.searchLabel,
  });

  final bool compact;
  final VoidCallback? onSearch;
  final String? searchLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    final size = compact ? t.spaceXxl : t.touchWeb;
    final button = InkWell(
      customBorder: const CircleBorder(),
      onTap: onSearch,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: c.primary, shape: BoxShape.circle),
        child: Icon(
          AppIcons.iconFor(AppIcons.search, context),
          color: c.onPrimary,
          size: compact ? t.iconSm : t.iconMd,
        ),
      ),
    );
    return Semantics(
      button: true,
      label: searchLabel,
      child: searchLabel == null
          ? button
          : Tooltip(message: searchLabel!, child: button),
    );
  }
}
