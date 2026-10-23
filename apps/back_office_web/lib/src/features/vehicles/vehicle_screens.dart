import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

StatusStyle _vehicleStyle(String status) {
  try {
    return VehicleStatus.values.byName(status).style;
  } catch (_) {
    return StatusStyle.offline;
  }
}

/// BO-15 Vehicle List (13 §6): typographic rows/cards, pill filters with
/// real counts, List/Cards toggle, sheets + Open-full-page. No big
/// illustrations on cards, no cartoon hero grids.
class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    void openIt(VehicleInfo v) => openDetail(
          context,
          title: v.registration,
          preview: _Preview(vehicle: v),
          fullRoute: AppRoutes.vehicleDetail(v.id),
          openFullLabel: l10n.sheet_open_full,
        );
    return R3ListView<VehicleInfo>(
      screenId: 'bo15',
      title: l10n.nav_vehicles,
      searchHint: l10n.mst_search,
      value: ref.watch(vehiclesProvider),
      filterOf: (VehicleInfo v) => v.status,
      filterLabel: (String raw) => masterStatusLabel(raw, l10n),
      searchIn: (VehicleInfo v) =>
          '${v.registration} ${v.id} ${v.status}'.toLowerCase(),
      row: (VehicleInfo v) => _row(context, l10n, v, () => openIt(v)),
      card: (VehicleInfo v) => _card(context, l10n, v, () => openIt(v)),
      onOpen: openIt,
      emptyTitle: l10n.bo15_empty,
      emptyMessage: l10n.mst_empty_message,
      emptyActionLabel: l10n.mst_create,
      onEmptyAction: () => openMasterPage(context, const VehicleFormScreen()),
      loadingTitle: l10n.bo15_loading,
      errorTitle: l10n.bo15_error,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(vehiclesProvider),
      successTitle: l10n.bo15_success,
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const VehicleFormScreen()),
      countLabel: l10n.list_rows,
    );
  }

  Widget _row(
    BuildContext context,
    AppLocalizations l10n,
    VehicleInfo v,
    VoidCallback onTap,
  ) {
    final qty = QuantityFmt(numbers: const NumberFmt());
    return TTListRow(
      title: v.registration,
      subtitle: '${v.id} · ${qty.ig(v.onBoardTenths, l10n.unitIg)}',
      initials: initialsOf(v.registration),
      style: _vehicleStyle(v.status),
      pillLabel: masterStatusLabel(v.status, l10n),
      onTap: onTap,
    );
  }

  Widget _card(
    BuildContext context,
    AppLocalizations l10n,
    VehicleInfo v,
    VoidCallback onTap,
  ) {
    final qty = QuantityFmt(numbers: const NumberFmt());
    final unit = l10n.unitIg;
    return TTEntityCard(
      title: v.registration,
      subtitle:
          '${l10n.mst_capacity} ${qty.ig(v.capacityTenths, unit)} · ${v.id}',
      details: ['${l10n.mst_onboard} ${qty.ig(v.onBoardTenths, unit)}'],
      statusStyle: _vehicleStyle(v.status),
      statusLabel: masterStatusLabel(v.status, l10n),
      footer: v.criticalDefect
          ? TTStatusPill(
              style: StatusStyle.critical,
              label: masterStatusLabel('breakdown', l10n),
            )
          : null,
      onTap: onTap,
    );
  }
}

/// Compact sheet preview for [openDetail] (summary + Open-full-page action
/// in the sheet chrome).
class _Preview extends StatelessWidget {
  const _Preview({required this.vehicle});

  final VehicleInfo vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final qty = QuantityFmt(numbers: const NumberFmt());
    final unit = l10n.unitIg;
    final docsOk = vehicle.docExpiryDays > 30;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(vehicle.registration, style: context.text.titleMedium),
        Text(vehicle.id, style: context.text.bodySmall),
        const TTGap.sm(),
        TTStatusPill(
          style: _vehicleStyle(vehicle.status),
          label: masterStatusLabel(vehicle.status, l10n),
        ),
        const TTGap.sm(),
        TTListTile(
          title: l10n.mst_capacity,
          trailing: Text(qty.ig(vehicle.capacityTenths, unit)),
        ),
        TTListTile(
          title: l10n.mst_onboard,
          trailing: Text(qty.ig(vehicle.onBoardTenths, unit)),
        ),
        TTListTile(
          title: l10n.detail_documents,
          trailing: Text(
            docsOk ? l10n.mst_docs_ok : l10n.mst_docs_expiring,
          ),
        ),
      ],
    );
  }
}

/// BO-16 Vehicle Detail: back arrow + H1, capacity/loaded/remaining metrics,
/// fleet identity, compartments table, calibration facts, availability
/// calendar, activity timeline. No cartoon hero grid (13 §2).
class VehicleDetailScreen extends ConsumerStatefulWidget {
  const VehicleDetailScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  ConsumerState<VehicleDetailScreen> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends ConsumerState<VehicleDetailScreen> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final vehicles = ref.watch(vehiclesProvider);
    final found =
        vehicles.valueOrNull?.where((v) => v.id == widget.vehicleId);
    final vehicle = found == null || found.isEmpty ? null : found.first;
    if (vehicle == null) {
      return const TTScaffold(body: TTSkeletonList());
    }
    final numbers = const NumberFmt();
    final qty = QuantityFmt(numbers: numbers);
    final unit = l10n.unitIg;
    final docsOk = vehicle.docExpiryDays > 30;
    final docsLabel = docsOk ? l10n.mst_docs_ok : l10n.mst_docs_expiring;
    final now = DateTime.now();
    final remaining = vehicle.capacityTenths - vehicle.onBoardTenths;
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const TTGap.md(),
        DetailHeader(
          title: vehicle.registration,
          onBack: () => context.pop(),
          actions: [
            TextButton(
              onPressed: () => openMasterPage(
                context,
                VehicleFormScreen(existing: vehicle),
              ),
              child: Text(l10n.detail_edit),
            ),
            TextButton(
              onPressed: () => showTTToast(
                context,
                message: '${l10n.detail_assign} · ${vehicle.registration}',
              ),
              child: Text(l10n.detail_assign),
            ),
          ],
        ),
        const TTGap.md(),
        if (vehicle.criticalDefect)
          TTBanner(
            kind: TTBannerKind.critical,
            message: l10n.veh_defect_block,
          ),
        if (vehicle.criticalDefect) const TTGap.md(),
        TTStatStrip(
          stats: [
            TTStatData(
              label: l10n.mst_capacity,
              value: qty.ig(vehicle.capacityTenths, unit),
            ),
            TTStatData(
              label: l10n.mst_onboard,
              value: qty.ig(vehicle.onBoardTenths, unit),
            ),
            TTStatData(
              label: l10n.dash_remaining,
              value: qty.ig(remaining < 0 ? 0 : remaining, unit),
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
                  title: vehicle.registration,
                  subtitle: vehicle.id,
                  trailing: TTStatusPill(
                    style: _vehicleStyle(vehicle.status),
                    label: masterStatusLabel(vehicle.status, l10n),
                  ),
                ),
                const TTDivider(),
                TTListTile(
                  title: l10n.detail_documents,
                  subtitle: docsLabel,
                ),
                if (vehicle.compartments.isNotEmpty) ...[
                  const TTDivider(),
                  for (var i = 0; i < vehicle.compartments.length; i++)
                    TTListTile(
                      title:
                          '${l10n.mst_capacity} ${i + 1}',
                      subtitle: vehicle.compartments[i],
                    ),
                ],
              ],
            ),
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.detail_availability,
          child: TTCard(
            child: TTMonthCalendar(
              year: now.year,
              month: now.month,
              commitments: demoCommitments(
                vehicle.registration,
                now.year,
                now.month,
              ),
              weekdayLabels: weekdayLabelsShort(context),
              selected: _selected,
              onSelectDay: (d) => setState(() => _selected = d),
            ),
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.detail_activity,
          child: TTTimeline(
            entries: [
              TTTimelineEntry(title: docsLabel),
              TTTimelineEntry(
                title: l10n.veh_balance,
                subtitle: qty.ig(vehicle.onBoardTenths, unit),
                color: vehicle.criticalDefect
                    ? context.status.critical
                    : context.status.completed,
              ),
            ],
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
          StatusChip(
            style: _vehicleStyle(vehicle.status),
            label: masterStatusLabel(vehicle.status, l10n),
          ),
          const TTGap.sm(),
          QuantityBadge(
            primary: qty.ig(vehicle.onBoardTenths, unit),
            secondary:
                '${l10n.mst_capacity} ${qty.ig(vehicle.capacityTenths, unit)}',
            state: vehicle.criticalDefect
                ? QuantityState.breach
                : vehicle.onBoardTenths < vehicle.capacityTenths ~/ 4
                    ? QuantityState.warn
                    : QuantityState.ok,
          ),
          const TTGap.md(),
          Text(docsLabel, style: context.text.bodyMedium),
          const TTGap.md(),
          TTButton(
            label: l10n.detail_edit,
            onPressed: () => openMasterPage(
              context,
              VehicleFormScreen(existing: vehicle),
            ),
          ),
        ],
      ),
    );
    final cta = l10n.detail_edit;
    final figure = qty.ig(vehicle.onBoardTenths, unit);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= context.tokens.breakpointTablet;
        if (wide) {
          return TTScaffold(
            body: SingleChildScrollView(
              child: TTSplitView(
                listPane: content,
                detailPane: actionCard,
              ),
            ),
          );
        }
        return TTScaffold(
          body: SingleChildScrollView(child: content),
          bottomBar: TTStickyBottomBar(
            number: figure,
            caption: vehicle.registration,
            ctaLabel: cta,
            onCta: () => openMasterPage(
              context,
              VehicleFormScreen(existing: vehicle),
            ),
          ),
        );
      },
    );
  }
}

class VehicleFormScreen extends ConsumerStatefulWidget {
  const VehicleFormScreen({super.key, this.existing});

  final VehicleInfo? existing;

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormState();
}

class _VehicleFormState extends ConsumerState<VehicleFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _registration;
  late final TextEditingController _capacity;
  late final TextEditingController _onboard;
  late String _status;
  late bool _criticalDefect;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _registration = TextEditingController(text: e?.registration ?? '');
    _capacity = TextEditingController(
      text: e == null ? '' : '${e.capacityTenths ~/ 10}',
    );
    _onboard = TextEditingController(
      text: e == null ? '' : '${e.onBoardTenths ~/ 10}',
    );
    _status = e?.status ?? 'available';
    _criticalDefect = e?.criticalDefect ?? false;
  }

  @override
  void dispose() {
    _registration.dispose();
    _capacity.dispose();
    _onboard.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String? required(String? v) =>
        v == null || v.trim().isEmpty ? l10n.requiredField : null;
    String? igTenths(String? v) {
      if (v == null || v.trim().isEmpty) return l10n.requiredField;
      final parsed = int.tryParse(v.trim());
      if (parsed == null || parsed < 0) return l10n.requiredField;
      return null;
    }

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
                    label: l10n.nav_vehicles,
                    controller: _registration,
                    validator: required,
                  ),
                  const TTGap.md(),
                  TTTextField(
                    label: l10n.mst_capacity,
                    controller: _capacity,
                    keyboardType: TextInputType.number,
                    validator: igTenths,
                  ),
                  const TTGap.md(),
                  TTTextField(
                    label: l10n.mst_onboard,
                    controller: _onboard,
                    keyboardType: TextInputType.number,
                    validator: igTenths,
                  ),
                  const TTGap.md(),
                  TTDropdown<String>(
                    label: l10n.mst_status,
                    value: _status,
                    items: [
                      for (final s in VehicleStatus.values)
                        TTDropdownItem(
                            value: s.name,
                            label: vehicleStatusLabel(s, l10n)),
                    ],
                    onChanged: (v) => setState(() => _status = v ?? _status),
                  ),
                  const TTGap.md(),
                  SwitchListTile(
                    title: Text(l10n.veh_defect_block),
                    value: _criticalDefect,
                    onChanged: (v) => setState(() => _criticalDefect = v),
                  ),
                  const TTGap.lg(),
                  TTButton(
                    label: l10n.mst_save,
                    onPressed: () {
                      if (!_form.currentState!.validate()) return;
                      final svc = ref.read(masterDataProvider);
                      final e = widget.existing;
                      final id = e?.id ??
                          svc.newIdFor('T-', 'vehicles', 'vehicle_id');
                      svc.saveVehicle(
                        VehicleInfo(
                          id: id,
                          registration: _registration.text.trim(),
                          capacityTenths: int.parse(_capacity.text.trim()) * 10,
                          onBoardTenths: int.parse(_onboard.text.trim()) * 10,
                          status: _status,
                          docExpiryDays: e?.docExpiryDays ?? 365,
                          criticalDefect: _criticalDefect,
                        ),
                      );
                      ref.invalidate(vehiclesProvider);
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
