import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

/// Depots master (simplified): typographic rows/cards + List/Cards toggle +
/// sheets + Open-full-page. Single "Active" pill carries the real count
/// (depots have no status dimension; the All pill stays deleted per 13 §2).
class DepotListScreen extends ConsumerWidget {
  const DepotListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    void openIt(Depot d) => openDetail(
          context,
          title: d.name(arabic: context.isArabic),
          preview: _Preview(depot: d),
          fullRoute: AppRoutes.depotDetail(d.id),
          openFullLabel: l10n.sheet_open_full,
        );
    return R3ListView<Depot>(
      screenId: 'depots',
      title: l10n.nav_depots,
      searchHint: l10n.mst_search,
      value: ref.watch(depotsProvider),
      filterOf: (_) => 'active',
      filterLabel: (String raw) => l10n.mst_active,
      searchIn: (Depot d) =>
          '${d.nameEn} ${d.nameAr} ${d.id} ${d.hours}'.toLowerCase(),
      row: (Depot d) => TTListRow(
        title: d.name(arabic: context.isArabic),
        subtitle: '${d.id} · ${l10n.depot_hours} ${d.hours}',
        initials: initialsOf(d.name(arabic: context.isArabic)),
        style: StatusStyle.completed,
        pillLabel: l10n.mst_active,
        onTap: () => openIt(d),
      ),
      card: (Depot d) => TTEntityCard(
        title: d.name(arabic: context.isArabic),
        subtitle: '${d.id} · ${l10n.depot_hours} ${d.hours}',
        statusStyle: StatusStyle.completed,
        statusLabel: l10n.mst_active,
        onTap: () => openIt(d),
      ),
      onOpen: openIt,
      emptyTitle: l10n.mst_empty_title,
      emptyMessage: l10n.mst_empty_message,
      emptyActionLabel: l10n.mst_create,
      onEmptyAction: () => openMasterPage(context, const DepotFormScreen()),
      loadingTitle: l10n.state_loading_title,
      errorTitle: l10n.state_error_title,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(depotsProvider),
      successTitle: l10n.state_success_title,
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const DepotFormScreen()),
      countLabel: l10n.list_rows,
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.depot});

  final Depot depot;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          depot.name(arabic: context.isArabic),
          style: context.text.titleMedium,
        ),
        Text(depot.id, style: context.text.bodySmall),
        const TTGap.sm(),
        TTStatusPill(
          style: StatusStyle.completed,
          label: l10n.mst_active,
        ),
        const TTGap.sm(),
        TTListTile(
          title: '${l10n.depot_hours} ${depot.hours}',
          subtitle:
              '${l10n.site_geofence} ${depot.geofenceM}',
        ),
      ],
    );
  }
}

class DepotDetailScreen extends ConsumerStatefulWidget {
  const DepotDetailScreen({super.key, required this.depotId});

  final String depotId;

  @override
  ConsumerState<DepotDetailScreen> createState() => _DepotDetailState();
}

class _DepotDetailState extends ConsumerState<DepotDetailScreen> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final depots = ref.watch(depotsProvider);
    final found = depots.valueOrNull?.where((d) => d.id == widget.depotId);
    final depot = found == null || found.isEmpty ? null : found.first;
    if (depot == null) {
      return const TTScaffold(body: TTSkeletonList());
    }
    final now = DateTime.now();
    final name = depot.name(arabic: context.isArabic);
    final geo =
        '${l10n.site_lat} ${depot.lat}, ${l10n.site_lng} ${depot.lng} · '
        '${l10n.site_geofence} ${depot.geofenceM}';
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TTGap.md(),
        DetailHeader(
          title: name,
          onBack: () => context.pop(),
          actions: [
            TextButton(
              onPressed: () => openMasterPage(
                context,
                DepotFormScreen(existing: depot),
              ),
              child: Text(l10n.detail_edit),
            ),
          ],
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.detail_overview,
          child: TTCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TTListTile(
                  leading: Icon(AppIcons.iconFor(AppIcons.depot, context)),
                  title: depot.id,
                  subtitle: geo,
                ),
                const TTDivider(),
                TTListTile(
                  leading: Icon(AppIcons.iconFor(AppIcons.clock, context)),
                  title: '${l10n.depot_hours} ${depot.hours}',
                ),
              ],
            ),
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.detail_location,
          child: TTCard(
            child: MiniMap(
              title: name,
              positions: [
                MapPosition(
                  id: depot.id,
                  lat: depot.lat,
                  lng: depot.lng,
                  style: StatusStyle.completed,
                  label: name,
                ),
              ],
            ),
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.depot_products,
          child: Wrap(
            spacing: context.tokens.spaceSm,
            runSpacing: context.tokens.spaceSm,
            children: [
              for (final p in depot.products) TTChip(label: p),
            ],
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.detail_availability,
          child: TTCard(
            child: TTMonthCalendar(
              year: now.year,
              month: now.month,
              commitments: demoCommitments(depot.id, now.year, now.month),
              weekdayLabels: weekdayLabelsShort(context),
              selected: _selected,
              onSelectDay: (d) => setState(() => _selected = d),
            ),
          ),
        ),
        const TTGap.xxl(),
      ],
    );
    final actionCard = TTStickyActionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(name, style: context.text.titleMedium),
          Text(depot.id, style: context.text.bodySmall),
          const TTGap.sm(),
          StatusChip(
            style: StatusStyle.completed,
            label: l10n.mst_active,
          ),
          const TTGap.sm(),
          Text(geo, style: context.text.bodyMedium),
          const TTGap.md(),
          TTButton(
            label: l10n.detail_edit,
            onPressed: () => openMasterPage(
              context,
              DepotFormScreen(existing: depot),
            ),
          ),
        ],
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= context.tokens.breakpointTablet;
        if (wide) {
          return TTScaffold(
            body: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: content),
                  const TTGap.lg(axis: Axis.horizontal),
                  SizedBox(
                    width: context.tokens.contentNarrow,
                    child: actionCard,
                  ),
                ],
              ),
            ),
          );
        }
        return TTScaffold(
          body: SingleChildScrollView(child: content),
          bottomBar: TTStickyBottomBar(
            number: depot.id,
            caption: name,
            ctaLabel: l10n.detail_edit,
            onCta: () => openMasterPage(
              context,
              DepotFormScreen(existing: depot),
            ),
          ),
        );
      },
    );
  }
}

class DepotFormScreen extends ConsumerStatefulWidget {
  const DepotFormScreen({super.key, this.existing});

  final Depot? existing;

  @override
  ConsumerState<DepotFormScreen> createState() => _DepotFormState();
}

class _DepotFormState extends ConsumerState<DepotFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nameEn;
  late final TextEditingController _nameAr;
  late final TextEditingController _hours;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameEn = TextEditingController(text: e?.nameEn ?? '');
    _nameAr = TextEditingController(text: e?.nameAr ?? '');
    _hours = TextEditingController(text: e?.hours ?? '');
  }

  @override
  void dispose() {
    _nameEn.dispose();
    _nameAr.dispose();
    _hours.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String? required(String? v) =>
        v == null || v.trim().isEmpty ? l10n.requiredField : null;
    final title = widget.existing == null ? l10n.mst_create : l10n.mst_edit;
    return TTScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TTGap.md(),
            DetailHeader(
              title: title,
              onBack: () => Navigator.of(context).pop(),
            ),
            const TTGap.md(),
            Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TTTextField(
                    label: l10n.mst_name_en,
                    controller: _nameEn,
                    validator: required,
                  ),
                  const TTGap.md(),
                  TTTextField(
                    label: l10n.mst_name_ar,
                    controller: _nameAr,
                    validator: required,
                  ),
                  const TTGap.md(),
                  TTTextField(
                    label: l10n.depot_hours,
                    controller: _hours,
                    validator: required,
                  ),
                  const TTGap.lg(),
                  TTButton(
                    label: l10n.mst_save,
                    onPressed: () {
                      if (!_form.currentState!.validate()) return;
                      final svc = ref.read(masterDataProvider);
                      final e = widget.existing;
                      final id = e?.id ??
                          svc.newIdFor('D-', 'depots', 'source_id');
                      svc.saveDepot(
                        Depot(
                          id: id,
                          nameEn: _nameEn.text.trim(),
                          nameAr: _nameAr.text.trim(),
                          lat: e?.lat ?? 0,
                          lng: e?.lng ?? 0,
                          geofenceM: e?.geofenceM ?? 0,
                          hours: _hours.text.trim(),
                          products: e?.products ?? const [],
                        ),
                      );
                      ref.invalidate(depotsProvider);
                      Navigator.of(context).pop();
                    },
                  ),
                  const TTGap.xxl(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
