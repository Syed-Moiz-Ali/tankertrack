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

class MasterRowData {
  const MasterRowData({
    required this.title,
    this.subtitle,
    this.chip,
    this.status,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? chip;
  final String? status;
  final VoidCallback? onTap;

  String get haystack => '${title.toLowerCase()} ${subtitle ?? ''}';
}

class MasterAsyncView<T> extends StatelessWidget {
  const MasterAsyncView({
    super.key,
    required this.value,
    required this.appBarTitle,
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
  final String appBarTitle;
  final Widget Function(List<T> items) data;
  final String emptyTitle;
  final String emptyMessage;
  final String errorTitle;
  final String retryLabel;
  final VoidCallback? onRetry;
  final VoidCallback? onCreate;
  final String? createLabel;

  TTAppBar _bar(BuildContext context) => TTAppBar(
        title: appBarTitle,
        actions: [
          if (onCreate != null && createLabel != null)
            TTIconButton(
              icon: Icon(AppIcons.iconFor(AppIcons.add, context)),
              semanticLabel: createLabel,
              tooltip: createLabel,
              onPressed: onCreate,
            ),
        ],
      );

  @override
  Widget build(BuildContext context) => value.when(
        loading: () => TTScaffold(
          appBar: _bar(context),
          body: const TTSkeletonList(),
        ),
        error: (e, _) => TTScaffold(
          appBar: _bar(context),
          body: TTErrorState(
            title: errorTitle,
            message: '$e',
            retryLabel: retryLabel,
            onRetry: onRetry,
          ),
        ),
        data: (items) => items.isEmpty
            ? TTScaffold(
                appBar: _bar(context),
                body: TTEmptyState(
                  title: emptyTitle,
                  message: emptyMessage,
                ),
              )
            : data(items),
      );
}

class MasterListView extends StatefulWidget {
  const MasterListView({
    super.key,
    required this.title,
    required this.searchHint,
    required this.allLabel,
    required this.rows,
    required this.countLabel,
    this.onCreate,
    this.createLabel,
    this.emptyTitle = '',
    this.emptyMessage = '',
  });

  final String title;
  final String searchHint;
  final String allLabel;
  final List<MasterRowData> rows;
  final String Function(int count) countLabel;
  final VoidCallback? onCreate;
  final String? createLabel;
  final String emptyTitle;
  final String emptyMessage;

  @override
  State<MasterListView> createState() => _MasterListViewState();
}

class _MasterListViewState extends State<MasterListView> {
  String _query = '';
  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.allLabel;
  }

  @override
  Widget build(BuildContext context) {
    final statuses = <String>[
      widget.allLabel,
      for (final s in {
        for (final r in widget.rows)
          if (r.status != null) r.status!
      })
        s,
    ];
    final q = _query.toLowerCase();
    final filtered = widget.rows
        .where(
          (r) =>
              (_status == widget.allLabel || r.status == _status) &&
              (q.isEmpty || r.haystack.toLowerCase().contains(q)),
        )
        .toList();
    return TTScaffold(
      appBar: TTAppBar(
        title: widget.title,
        actions: [
          if (widget.onCreate != null && widget.createLabel != null)
            TTIconButton(
              icon: Icon(AppIcons.iconFor(AppIcons.add, context)),
              semanticLabel: widget.createLabel,
              tooltip: widget.createLabel,
              onPressed: widget.onCreate,
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TTSearchBar(
            hint: widget.searchHint,
            onChanged: (v) => setState(() => _query = v),
          ),
          const TTGap.sm(),
          TTFilterPills(
            options: statuses,
            selected: _status,
            onSelected: (v) => setState(() => _status = v),
          ),
          const TTGap.sm(),
          Text(widget.countLabel(filtered.length),
              style: context.text.bodySmall),
          const TTGap.sm(),
          Expanded(
            child: filtered.isEmpty
                ? TTEmptyState(
                    title: widget.emptyTitle,
                    message: widget.emptyMessage,
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const TTGap.sm(),
                    itemBuilder: (context, i) {
                      final r = filtered[i];
                      return TTCard(
                        padding: EdgeInsets.all(context.tokens.spaceSm),
                        child: TTListTile(
                          title: r.title,
                          subtitle: r.subtitle,
                          trailing: r.chip,
                          onTap: r.onTap,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Alert severity strings (tracking/incident seeds) → display style.
StatusStyle alertSeverityStyle(String severity) => switch (severity) {
      'critical' => StatusStyle.critical,
      'warn' => StatusStyle.waiting,
      _ => StatusStyle.active,
    };

/// Detail page back bar (explicit pop; router gains typed routes in slice C).
TTAppBar masterDetailBar(BuildContext context, String title) => TTAppBar(
      title: title,
      leading: TTIconButton(
        icon: Icon(AppIcons.iconFor(AppIcons.back, context)),
        semanticLabel: title,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
