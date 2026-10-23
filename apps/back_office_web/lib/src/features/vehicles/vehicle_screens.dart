import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

AppIcon _vehicleIcon(String status) => switch (status) {
      'available' => AppIcons.check,
      'reserved' => AppIcons.pending,
      'loading' => AppIcons.fuelDrop,
      'inTransit' => AppIcons.navigation,
      'atCustomer' => AppIcons.customer,
      'onBreak' => AppIcons.clock,
      'breakdown' => AppIcons.breakdown,
      'maintenance' => AppIcons.settings,
      _ => AppIcons.offline,
    };

/// Vehicles master: R1 media-card grid + R2 detail + form.
class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vehicles = ref.watch(vehiclesProvider);
    return MasterAsyncView<VehicleInfo>(
      value: vehicles,
      emptyTitle: l10n.mst_empty_title,
      emptyMessage: l10n.mst_empty_message,
      errorTitle: l10n.mst_error_title,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(vehiclesProvider),
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const VehicleFormScreen()),
      data: (items) {
        final numbers = const NumberFmt();
        final qty = QuantityFmt(numbers: numbers);
        final unit = l10n.unitIg;
        final statuses = {
          for (final v in items) v.status,
        }.toList()
          ..sort();
        return MasterGridView(
          title: l10n.nav_vehicles,
          searchHint: l10n.mst_search,
          allLabel: l10n.mst_all,
          categories: [
            for (final s in statuses)
              MasterCategory(
                icon: _vehicleIcon(s),
                label: masterStatusLabel(s, l10n),
                value: s,
              ),
          ],
          rows: [
            for (final v in items)
              MasterCardData(
                title: v.registration,
                subtitle: v.id,
                figure:
                    '${qty.ig(v.onBoardTenths, unit)} · ${qty.ig(v.capacityTenths, unit)}',
                badge: masterStatusLabel(v.status, l10n),
                status: v.status,
                image:
                    SvgPicture.asset(AppAssets.tanker, fit: BoxFit.contain),
                onTap: () => context.go(AppRoutes.vehicleDetail(v.id)),
              ),
          ],
          countLabel: l10n.list_rows,
          emptyTitle: l10n.mst_empty_title,
          emptyMessage: l10n.mst_empty_message,
          createLabel: l10n.mst_create,
          onCreate: () => openMasterPage(context, const VehicleFormScreen()),
        );
      },
    );
  }
}

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
        TTImageGrid(
          images: illustrationCells(const [
            AppAssets.tanker,
            AppAssets.depot,
            AppAssets.emptyMap,
            AppAssets.driver,
            AppAssets.breakdown,
          ]),
          showAllLabel: l10n.detail_photos,
          onShowAll: () => openIllustrationGallery(
            context,
            title: l10n.detail_photos,
            uris: const [
              AppAssets.tanker,
              AppAssets.depot,
              AppAssets.emptyMap,
              AppAssets.driver,
              AppAssets.breakdown,
            ],
          ),
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
                ),
                const TTDivider(),
                TTListTile(
                  title: l10n.mst_capacity,
                  subtitle: qty.ig(vehicle.capacityTenths, unit),
                ),
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
            style: VehicleStatus.values.byName(vehicle.status).style,
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
