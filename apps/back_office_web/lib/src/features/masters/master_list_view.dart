import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 7 localized short weekday names in locale week order (narrow names from
/// [MaterialLocalizations], rotated by the locale's first day of week).
/// Zero literals: names come from the framework localizations.
List<String> weekdayLabelsShort(BuildContext context) {
  final ml = MaterialLocalizations.of(context);
  final days = ml.narrowWeekdays;
  final first = ml.firstDayOfWeekIndex % days.length;
  return [...days.sublist(first), ...days.sublist(0, first)];
}

/// Shared list chrome for all P1 masters (slice D).
///
/// TTScaffold + sticky TTSearchBar + TTFilterPills + virtualized list +
/// TTSkeleton/TTEmptyState/TTErrorState. Screens map entities to
/// [MasterRowData]; filtering is in-memory (query + status pill).
void openMasterPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

/// One grid card (R1): title + grey subtitle + bold figure, overlay badge
/// label, optional illustration, raw `status` key for category filtering.
/// Lite rows use [trailing] instead of the overlay [badge].
class MasterCardData {
  const MasterCardData({
    required this.title,
    this.subtitle,
    this.figure,
    this.badge,
    this.trailing,
    this.status,
    this.image,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? figure;
  final String? badge;
  final Widget? trailing;
  final String? status;
  final Widget? image;
  final VoidCallback? onTap;

  String get haystack =>
      '${title.toLowerCase()} ${subtitle ?? ''} ${figure ?? ''}'.toLowerCase();
}

/// One category pill: localized label + raw filter value.
class MasterCategory {
  const MasterCategory({
    required this.icon,
    required this.label,
    required this.value,
  });

  final AppIcon icon;
  final String label;

  /// Empty value = "All".
  final String value;
}

class MasterAsyncView<T> extends StatelessWidget {
  const MasterAsyncView({
    super.key,
    required this.value,
    required this.data,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.errorTitle,
    required this.retryLabel,
    this.onRetry,
    this.onCreate,
    this.createLabel,
  });

  final AsyncValue<List<T>> value;
  final Widget Function(List<T> items) data;
  final String emptyTitle;
  final String emptyMessage;
  final String errorTitle;
  final String retryLabel;
  final VoidCallback? onRetry;
  final VoidCallback? onCreate;
  final String? createLabel;

  @override
  Widget build(BuildContext context) => value.when(
        loading: () => const TTScaffold(body: TTSkeletonList()),
        error: (e, _) => TTScaffold(
          body: TTErrorState(
            title: errorTitle,
            message: '$e',
            retryLabel: retryLabel,
            onRetry: onRetry,
          ),
        ),
        data: (items) => items.isEmpty
            ? TTScaffold(
                body: TTEmptyState(
                  title: emptyTitle,
                  message: emptyMessage,
                  actionLabel: createLabel,
                  onAction: onCreate,
                ),
              )
            : data(items),
      );
}

/// R1 media-card grid (fleet lists): search + [TTCategoryBar] pills +
/// responsive 2→6 grid of [TTMediaCard]s. Shell owns the top nav, so this
/// renders header + content only.
class MasterGridView extends StatefulWidget {
  const MasterGridView({
    super.key,
    required this.title,
    required this.searchHint,
    required this.allLabel,
    required this.categories,
    required this.rows,
    required this.countLabel,
    required this.emptyTitle,
    required this.emptyMessage,
    this.onCreate,
    this.createLabel,
  });

  final String title;
  final String searchHint;
  final String allLabel;
  final List<MasterCategory> categories;
  final List<MasterCardData> rows;
  final String Function(int count) countLabel;
  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback? onCreate;
  final String? createLabel;

  @override
  State<MasterGridView> createState() => _MasterGridViewState();
}

class _MasterGridViewState extends State<MasterGridView> {
  String _query = '';
  String _category = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final filtered = widget.rows
        .where(
          (r) =>
              (_category.isEmpty || r.status == _category) &&
              (q.isEmpty || r.haystack.contains(q)),
        )
        .toList();
    final counted = widget.countLabel(filtered.length);
    return TTScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TTGap.md(),
            TTSectionHeader(
              title: widget.title,
              actionLabel: widget.createLabel,
              onAction: widget.onCreate,
            ),
            const TTGap.sm(),
            TTSearchBar(
              hint: widget.searchHint,
              onChanged: (v) => setState(() => _query = v),
            ),
            const TTGap.sm(),
            TTCategoryBar(
              items: [
                TTCategoryItem(icon: AppIcons.search, label: widget.allLabel),
                for (final c in widget.categories)
                  TTCategoryItem(icon: c.icon, label: c.label),
              ],
              selected: _selectedIndex,
              onSelect: (i) => setState(
                () => _category =
                    i == 0 ? '' : widget.categories[i - 1].value,
              ),
            ),
            const TTGap.sm(),
            Text(counted, style: context.text.bodySmall),
            const TTGap.sm(),
            LayoutBuilder(
              builder: (context, constraints) {
                if (filtered.isEmpty) {
                  return TTEmptyState(
                    title: widget.emptyTitle,
                    message: widget.emptyMessage,
                  );
                }
                final max = constraints.maxWidth;
                final cols = max >= context.tokens.breakpointDesktop
                    ? 4
                    : max >= context.tokens.breakpointTablet
                        ? 3
                        : 2;
                final gap = context.tokens.gridGap;
                final cellWidth = (max - gap * (cols - 1)) / cols;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final r in filtered)
                      SizedBox(
                        width: cellWidth,
                        child: TTMediaCard(
                          image: r.image,
                          title: r.title,
                          subtitle: r.subtitle,
                          figure: r.figure,
                          badge: r.badge,
                          onTap: r.onTap,
                        ),
                      ),
                  ],
                );
              },
            ),
            const TTGap.xxl(),
          ],
        ),
      ),
    );
  }

  int get _selectedIndex {
    if (_category.isEmpty) return 0;
    final i = widget.categories.indexWhere((c) => c.value == _category);
    return i < 0 ? 0 : i + 1;
  }
}

/// Lighter card-grid language (depots / products): same search + category
/// chrome, simple [TTCard] rows instead of media cards.
class MasterLiteGrid extends StatefulWidget {
  const MasterLiteGrid({
    super.key,
    required this.title,
    required this.searchHint,
    required this.allLabel,
    required this.categories,
    required this.rows,
    required this.countLabel,
    required this.emptyTitle,
    required this.emptyMessage,
    this.onCreate,
    this.createLabel,
  });

  final String title;
  final String searchHint;
  final String allLabel;
  final List<MasterCategory> categories;
  final List<MasterCardData> rows;
  final String Function(int count) countLabel;
  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback? onCreate;
  final String? createLabel;

  @override
  State<MasterLiteGrid> createState() => _MasterLiteGridState();
}

class _MasterLiteGridState extends State<MasterLiteGrid> {
  String _query = '';
  String _category = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final filtered = widget.rows
        .where(
          (r) =>
              (_category.isEmpty || r.status == _category) &&
              (q.isEmpty || r.haystack.contains(q)),
        )
        .toList();
    final counted = widget.countLabel(filtered.length);
    return TTScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TTGap.md(),
            TTSectionHeader(
              title: widget.title,
              actionLabel: widget.createLabel,
              onAction: widget.onCreate,
            ),
            const TTGap.sm(),
            TTSearchBar(
              hint: widget.searchHint,
              onChanged: (v) => setState(() => _query = v),
            ),
            const TTGap.sm(),
            TTCategoryBar(
              items: [
                TTCategoryItem(icon: AppIcons.search, label: widget.allLabel),
                for (final c in widget.categories)
                  TTCategoryItem(icon: c.icon, label: c.label),
              ],
              selected: _selectedIndex,
              onSelect: (i) => setState(
                () => _category =
                    i == 0 ? '' : widget.categories[i - 1].value,
              ),
            ),
            const TTGap.sm(),
            Text(counted, style: context.text.bodySmall),
            const TTGap.sm(),
            if (filtered.isEmpty)
              TTEmptyState(
                title: widget.emptyTitle,
                message: widget.emptyMessage,
              )
            else
              for (final r in filtered)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: context.tokens.spaceSm,
                  ),
                  child: TTCard(
                    padding: EdgeInsets.all(context.tokens.spaceSm),
                    onTap: r.onTap,
                  child: TTListTile(
                    title: r.title,
                    subtitle: r.subtitle,
                    trailing: r.trailing,
                  ),
                  ),
                ),
            const TTGap.xxl(),
          ],
        ),
      ),
    );
  }

  int get _selectedIndex {
    if (_category.isEmpty) return 0;
    final i = widget.categories.indexWhere((c) => c.value == _category);
    return i < 0 ? 0 : i + 1;
  }
}

/// R2 detail header: back arrow + H1 + right-aligned text actions.
/// The shell owns the top nav, so details render this in-content.
class DetailHeader extends StatelessWidget {
  const DetailHeader({
    super.key,
    required this.title,
    required this.onBack,
    this.actions = const [],
  });

  final String title;
  final VoidCallback onBack;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TTIconButton(
          icon: Icon(AppIcons.iconFor(AppIcons.back, context)),
          semanticLabel: title,
          onPressed: onBack,
        ),
        const TTGap.sm(axis: Axis.horizontal),
        Expanded(
          child: Text(
            title,
            style: context.text.headlineSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        for (final a in actions) ...[
          const TTGap.sm(axis: Axis.horizontal),
          a,
        ],
      ],
    );
  }
}

/// Alert severity strings (tracking/incident seeds) → display style.
StatusStyle alertSeverityStyle(String severity) => switch (severity) {
      'critical' => StatusStyle.critical,
      'warn' => StatusStyle.waiting,
      _ => StatusStyle.active,
    };
