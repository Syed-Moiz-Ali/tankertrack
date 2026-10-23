import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

/// Drivers master: list + detail (licence + commitments calendar) + form.
class DriverListScreen extends ConsumerWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final drivers = ref.watch(driversProvider);
    return MasterAsyncView<DriverInfo>(
      value: drivers,
      appBarTitle: l10n.nav_drivers,
      emptyTitle: l10n.mst_empty_title,
      emptyMessage: l10n.mst_empty_message,
      errorTitle: l10n.mst_error_title,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(driversProvider),
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const DriverFormScreen()),
      data: (items) => MasterListView(
        title: l10n.nav_drivers,
        searchHint: l10n.mst_search,
        allLabel: l10n.mst_all,
        countLabel: l10n.list_rows,
        emptyTitle: l10n.mst_empty_title,
        emptyMessage: l10n.mst_empty_message,
        createLabel: l10n.mst_create,
        onCreate: () => openMasterPage(context, const DriverFormScreen()),
        rows: [
          for (final d in items)
            MasterRowData(
              title: d.name(arabic: context.isArabic),
              subtitle: '${d.id} · ${d.phone}',
              status: d.status,
              chip: StatusChip(
                style: driverStatusStyle(d.status),
                label: masterStatusLabel(d.status, l10n),
              ),
              onTap: () => context.go(AppRoutes.driverDetail(d.id)),
            ),
        ],
      ),
    );
  }
}

StatusStyle driverStatusStyle(String status) => switch (status) {
      'onDuty' => StatusStyle.active,
      'offDuty' => StatusStyle.offline,
      'leave' => StatusStyle.waiting,
      _ => StatusStyle.critical,
    };

class DriverDetailScreen extends ConsumerStatefulWidget {
  const DriverDetailScreen({super.key, required this.driverId});

  final String driverId;

  @override
  ConsumerState<DriverDetailScreen> createState() => _DriverDetailState();
}

class _DriverDetailState extends ConsumerState<DriverDetailScreen> {
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final drivers = ref.watch(driversProvider);
    final found =
        drivers.valueOrNull?.where((d) => d.id == widget.driverId);
    final driver = found == null || found.isEmpty ? null : found.first;
    if (driver == null) {
      return TTScaffold(
        appBar: masterDetailBar(context, l10n.nav_drivers),
        body: const TTSkeletonList(),
      );
    }
    final now = DateTime.now();
    final commitments =
        demoCommitments(driver.id, now.year, now.month);
    return TTScaffold(
      appBar:
          masterDetailBar(context, driver.name(arabic: context.isArabic)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TTSection(
              title: driver.id,
              child: TTCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(driver.phone, style: context.text.bodyMedium),
                    const TTGap.sm(),
                    Text(
                      '${l10n.drv_licence} ${driver.licenceExpiryDays}',
                      style: context.text.bodyMedium,
                    ),
                    const TTGap.sm(),
                    StatusChip(
                      style: driverStatusStyle(driver.status),
                      label: masterStatusLabel(driver.status, l10n),
                    ),
                  ],
                ),
              ),
            ),
            const TTGap.lg(),
            TTSection(
              title: l10n.drv_calendar_title,
              child: TTCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.drv_commitments} · ${l10n.cal_commitment_days}',
                      style: context.text.bodySmall,
                    ),
                    const TTGap.sm(),
                    TTMonthCalendar(
                      year: now.year,
                      month: now.month,
                      commitments: commitments,
                      weekdayLabels: weekdayLabelsShort(context),
                      selected: _selected,
                      onSelectDay: (d) => setState(() => _selected = d),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DriverFormScreen extends ConsumerStatefulWidget {
  const DriverFormScreen({super.key, this.existing});

  final DriverInfo? existing;

  @override
  ConsumerState<DriverFormScreen> createState() => _DriverFormState();
}

class _DriverFormState extends ConsumerState<DriverFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nameEn;
  late final TextEditingController _nameAr;
  late final TextEditingController _phone;
  late String _status;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameEn = TextEditingController(text: e?.nameEn ?? '');
    _nameAr = TextEditingController(text: e?.nameAr ?? '');
    _phone = TextEditingController(text: e?.phone ?? '');
    _status = e?.status ?? 'onDuty';
  }

  @override
  void dispose() {
    _nameEn.dispose();
    _nameAr.dispose();
    _phone.dispose();
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
                label: l10n.mst_phone,
                controller: _phone,
                keyboardType: TextInputType.phone,
                validator: required,
              ),
              const TTGap.md(),
              TTDropdown<String>(
                label: l10n.mst_status,
                value: _status,
                items: [
                  for (final s in ['onDuty', 'offDuty', 'leave', 'suspended'])
                    TTDropdownItem(
                        value: s, label: masterStatusLabel(s, l10n)),
                ],
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
              const TTGap.lg(),
              TTButton(
                label: l10n.mst_save,
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  final svc = ref.read(masterDataProvider);
                  final e = widget.existing;
                  final id = e?.id ??
                      svc.newIdFor('DRV-', 'drivers', 'driver_id');
                  svc.saveDriver(
                    DriverInfo(
                      id: id,
                      nameEn: _nameEn.text.trim(),
                      nameAr: _nameAr.text.trim(),
                      phone: _phone.text.trim(),
                      status: _status,
                      licenceExpiryDays: e?.licenceExpiryDays ?? 365,
                    ),
                  );
                  ref.invalidate(driversProvider);
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
