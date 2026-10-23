import 'package:data/data.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

/// Depots master: list + detail + create/edit form.
class DepotListScreen extends ConsumerWidget {
  const DepotListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final depots = ref.watch(depotsProvider);
    return MasterAsyncView<Depot>(
      value: depots,
      appBarTitle: l10n.nav_depots,
      emptyTitle: l10n.mst_empty_title,
      emptyMessage: l10n.mst_empty_message,
      errorTitle: l10n.mst_error_title,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(depotsProvider),
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const DepotFormScreen()),
      data: (items) => MasterListView(
        title: l10n.nav_depots,
        searchHint: l10n.mst_search,
        allLabel: l10n.mst_all,
        countLabel: l10n.list_rows,
        emptyTitle: l10n.mst_empty_title,
        emptyMessage: l10n.mst_empty_message,
        createLabel: l10n.mst_create,
        onCreate: () => openMasterPage(context, const DepotFormScreen()),
        rows: [
          for (final d in items)
            MasterRowData(
              title: d.name(arabic: context.isArabic),
              subtitle: '${l10n.depot_hours} ${d.hours}',
              status: l10n.mst_active,
              chip: StatusChip(
                style: StatusStyle.completed,
                label: l10n.mst_active,
              ),
              onTap: () => context.go(AppRoutes.depotDetail(d.id)),
            ),
        ],
      ),
    );
  }
}

class DepotDetailScreen extends ConsumerWidget {
  const DepotDetailScreen({super.key, required this.depotId});

  final String depotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final depots = ref.watch(depotsProvider);
    final found = depots.valueOrNull?.where((d) => d.id == depotId);
    final depot = found == null || found.isEmpty ? null : found.first;
    if (depot == null) {
      return TTScaffold(
        appBar: masterDetailBar(context, l10n.nav_depots),
        body: const TTSkeletonList(),
      );
    }
    return TTScaffold(
      appBar:
          masterDetailBar(context, depot.name(arabic: context.isArabic)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TTSection(
              title: depot.id,
              child: TTCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.site_lat} ${depot.lat}, '
                      '${l10n.site_lng} ${depot.lng} · '
                      '${l10n.site_geofence} ${depot.geofenceM}',
                      style: context.text.bodyMedium,
                    ),
                    const TTGap.sm(),
                    Text(
                      '${l10n.depot_hours} ${depot.hours}',
                      style: context.text.bodyMedium,
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
          ],
        ),
      ),
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
    return TTScaffold(
      appBar: masterDetailBar(
        context,
        widget.existing == null ? l10n.mst_create : l10n.mst_edit,
      ),
      body: SingleChildScrollView(
        child: Form(
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
            ],
          ),
        ),
      ),
    );
  }
}
