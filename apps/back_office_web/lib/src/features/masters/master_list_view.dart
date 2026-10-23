import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../ui/demo_state.dart';

/// 7 localized short weekday names in locale week order (narrow names from
/// [MaterialLocalizations], rotated by the locale's first day of week).
/// Zero literals: names come from the framework localizations.
List<String> weekdayLabelsShort(BuildContext context) {
  final ml = MaterialLocalizations.of(context);
  final days = ml.narrowWeekdays;
  final first = ml.firstDayOfWeekIndex % days.length;
  return [...days.sublist(first), ...days.sublist(0, first)];
}

/// Pushes full-page forms/details over the list (narrow screens use this
/// for every row tap; wide screens prefer [openDetail] sheets).
void openMasterPage(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

/// Initials for avatar rows (first letters of the first two words).
String initialsOf(String name) {
  final parts = name.split(' ').where((p) => p.isNotEmpty);
  return parts.take(2).map((p) => p.substring(0, 1)).join();
}

/// R3 detail opener (13 §6): wide screens get a design_system [TTSideSheet]
/// preview with the contract `sheet_open_full` action; narrow screens
/// navigate to the full page directly.
void openDetail(
  BuildContext context, {
  required String title,
  required Widget preview,
  required String fullRoute,
  required String openFullLabel,
}) {
  final wide =
      MediaQuery.widthOf(context) >= context.tokens.breakpointTablet;
  if (!wide) {
    context.go(fullRoute);
    return;
  }
  showTTSideSheet<void>(
    context,
    title: title,
    openFullPageLabel: openFullLabel,
    onOpenFullPage: () => context.go(fullRoute),
    child: preview,
  );
}

/// R3 list filter: raw status value + localized label + real row count.
/// There is deliberately NO "All" pseudo-pill (13 §2: the All pill is
/// deleted); tapping the active pill clears back to the full list.
class R3Filter {
  const R3Filter({
    required this.value,
    required this.label,
    required this.count,
  });

  final String value;
  final String label;
  final int count;
}

/// List/Cards view toggle (contracts §3 `list_cards` / `list_list`).
class ListCardsToggle extends StatelessWidget {
  const ListCardsToggle({
    super.key,
    required this.cards,
    required this.onChanged,
  });

  final bool cards;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SegmentedButton<bool>(
      segments: [
        ButtonSegment(value: false, label: Text(l10n.list_list)),
        ButtonSegment(value: true, label: Text(l10n.list_cards)),
      ],
      selected: {cards},
      onSelectionChanged: (Set<bool> next) => onChanged(next.first),
    );
  }
}

/// R3 master list (13 §6): H1 + count line, search, pill filters with real
/// counts, List/Cards toggle, typographic rows ([TTListRow]) or cards
/// ([TTEntityCard]). Companion states via the design_system [ScreenStateHost]
/// (per-screen `boXX_*` copy + demo switcher). Styling ONLY via theme.
class R3ListView<T> extends ConsumerStatefulWidget {
  const R3ListView({
    super.key,
    required this.screenId,
    required this.title,
    required this.searchHint,
    required this.value,
    required this.filterOf,
    required this.filterLabel,
    required this.searchIn,
    required this.row,
    required this.card,
    required this.onOpen,
    required this.emptyTitle,
    required this.emptyMessage,
    this.emptyActionLabel,
    this.onEmptyAction,
    required this.loadingTitle,
    required this.errorTitle,
    required this.retryLabel,
    this.onRetry,
    required this.successTitle,
    this.createLabel,
    this.onCreate,
    required this.countLabel,
  });

  /// Demo-switcher id (e.g. 'bo15').
  final String screenId;
  final String title;
  final String searchHint;

  /// Provider state.
  final AsyncValue<List<T>> value;

  /// Raw status key per item (groups the pill filters).
  final String Function(T item) filterOf;

  /// Localized label per raw status key.
  final String Function(String raw) filterLabel;

  /// Search haystack per item (lowercased by the view).
  final String Function(T item) searchIn;

  /// Typographic row / card per item (bare content; taps handled by [onOpen]
  /// via the row/card `onTap`).
  final Widget Function(T item) row;
  final Widget Function(T item) card;

  /// Row/card tap (usually [openDetail]).
  final void Function(T item) onOpen;

  /// Companion copy (per-screen `boXX_*` + shared keys).
  final String emptyTitle;
  final String emptyMessage;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;
  final String loadingTitle;
  final String errorTitle;
  final String retryLabel;
  final VoidCallback? onRetry;
  final String successTitle;

  final String? createLabel;
  final VoidCallback? onCreate;

  /// Localized '{count} rows' formatter.
  final String Function(int count) countLabel;

  @override
  ConsumerState<R3ListView<T>> createState() => _R3ListViewState<T>();
}

class _R3ListViewState<T> extends ConsumerState<R3ListView<T>> {
  String _query = '';
  String _filter = '';
  bool _cards = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final forced = ref.watch(demoScreenStateProvider(widget.screenId));
    final live = widget.value.when(
      loading: () => ScreenStateKind.loading,
      error: (_, __) => ScreenStateKind.error,
      data: (List<T> items) =>
          items.isEmpty ? ScreenStateKind.empty : ScreenStateKind.success,
    );
    final kind = demoKind(forced) ?? live;
    final items = widget.value.valueOrNull ?? const [];
    final shown = _applyFilters(items);
    return TTScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const TTGap.md(),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: context.text.headlineSmall,
                ),
              ),
              if (widget.createLabel != null) ...[
                const TTGap.sm(axis: Axis.horizontal),
                TTButton(
                  expanded: false,
                  label: widget.createLabel!,
                  onPressed: widget.onCreate,
                ),
              ],
            ],
          ),
          const TTGap.md(),
          TTSearchBar(
            hint: widget.searchHint,
            onChanged: (String v) => setState(() => _query = v),
          ),
          const TTGap.sm(),
          Expanded(
            child: ScreenStateHost(
              state: kind,
              emptyTitle: widget.emptyTitle,
              emptyMessage: widget.emptyMessage,
              emptyActionLabel: widget.emptyActionLabel,
              onEmptyAction: widget.onEmptyAction,
              loadingLabel: widget.loadingTitle,
              errorTitle: widget.errorTitle,
              errorMessage: widget.errorTitle,
              retryLabel: widget.retryLabel,
              onRetry: widget.onRetry,
              demoTitle: AppFlags.isDemoBuild ? l10n.demo_screen_state : null,
              demoLabels:
                  AppFlags.isDemoBuild ? demoLabels(l10n) : null,
              onDemoSelect: AppFlags.isDemoBuild
                  ? (ScreenStateKind next) => ref
                      .read(
                        demoScreenStateProvider(widget.screenId).notifier,
                      )
                      .state = next == demoKind(forced)
                          ? DemoScreenState.live
                          : DemoScreenState.values.firstWhere(
                              (DemoScreenState s) => demoKind(s) == next,
                            )
                  : null,
              child: forced == DemoScreenState.success
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TTBanner(message: widget.successTitle),
                        const TTGap.sm(),
                        Expanded(child: _content(items: shown)),
                      ],
                    )
                  : _content(items: shown),
            ),
          ),
        ],
      ),
    );
  }

  List<R3Filter> _filters(List<T> items) {
    final counts = <String, int>{};
    for (final item in items) {
      final key = widget.filterOf(item);
      counts.update(key, (c) => c + 1, ifAbsent: () => 1);
    }
    final keys = counts.keys.toList()..sort();
    final numbers = const NumberFmt();
    return [
      for (final key in keys)
        R3Filter(
          value: key,
          label:
              '${widget.filterLabel(key)} · ${numbers.integer(counts[key]!)}',
          count: counts[key]!,
        ),
    ];
  }

  List<T> _applyFilters(List<T> items) {
    final q = _query.toLowerCase();
    return items
        .where(
          (T item) =>
              (_filter.isEmpty || widget.filterOf(item) == _filter) &&
              (q.isEmpty || widget.searchIn(item).toLowerCase().contains(q)),
        )
        .toList();
  }

  Widget _content({required List<T> items}) {
    final filters = _filters(widget.value.valueOrNull ?? const []);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final f in filters)
                  Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: context.tokens.spaceSm,
                    ),
                    child: FilterChip(
                      label: Text(f.label),
                      selected: _filter == f.value,
                      onSelected: (_) => setState(
                        () => _filter = _filter == f.value ? '' : f.value,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const TTGap.sm(),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.countLabel(items.length),
                  style: context.text.bodySmall,
                ),
              ),
              ListCardsToggle(
                cards: _cards,
                onChanged: (bool next) => setState(() => _cards = next),
              ),
            ],
          ),
          const TTGap.sm(),
          if (items.isEmpty)
            TTEmptyState(
              title: widget.emptyTitle,
              message: widget.emptyMessage,
            )
          else if (_cards)
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final max = constraints.maxWidth;
                final cols = max >= context.tokens.breakpointDesktop
                    ? 3
                    : max >= context.tokens.breakpointTablet
                        ? 2
                        : 1;
                final gap = context.tokens.gridGap;
                final cellWidth = (max - gap * (cols - 1)) / cols;
                return Wrap(
                  spacing: gap,
                  runSpacing: gap,
                  children: [
                    for (final item in items)
                      SizedBox(
                        width: cellWidth,
                        child: widget.card(item),
                      ),
                  ],
                );
              },
            )
          else
            for (final item in items)
              Padding(
                padding: EdgeInsets.only(bottom: context.tokens.spaceSm),
                child: widget.row(item),
              ),
          const TTGap.xxl(),
        ],
      ),
    );
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
