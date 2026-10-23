import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

StatusStyle driverStatusStyle(String status) => switch (status) {
      'onDuty' => StatusStyle.active,
      'offDuty' => StatusStyle.offline,
      'leave' => StatusStyle.waiting,
      _ => StatusStyle.critical,
    };

/// BO-17 Driver List (13 §6): typographic rows/cards, pill filters with
/// real counts, List/Cards toggle, sheets + Open-full-page.
class DriverListScreen extends ConsumerWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    void openIt(DriverInfo d) => openDetail(
          context,
          title: d.name(arabic: context.isArabic),
          preview: _Preview(driver: d),
          fullRoute: AppRoutes.driverDetail(d.id),
          openFullLabel: l10n.sheet_open_full,
        );
    return R3ListView<DriverInfo>(
      screenId: 'bo17',
      title: l10n.nav_drivers,
      searchHint: l10n.mst_search,
      value: ref.watch(driversProvider),
      filterOf: (DriverInfo d) => d.status,
      filterLabel: (String raw) => masterStatusLabel(raw, l10n),
      searchIn: (DriverInfo d) =>
          '${d.nameEn} ${d.nameAr} ${d.id} ${d.phone}'.toLowerCase(),
      row: (DriverInfo d) => TTListRow(
        title: d.name(arabic: context.isArabic),
        subtitle: '${d.id} · ${d.phone}',
        initials: initialsOf(d.name(arabic: context.isArabic)),
        style: driverStatusStyle(d.status),
        pillLabel: masterStatusLabel(d.status, l10n),
        onTap: () => openIt(d),
      ),
      card: (DriverInfo d) => TTEntityCard(
        title: d.name(arabic: context.isArabic),
        subtitle: '${d.id} · ${d.phone}',
        details: ['${l10n.drv_licence} ${d.licenceExpiryDays}'],
        statusStyle: driverStatusStyle(d.status),
        statusLabel: masterStatusLabel(d.status, l10n),
        onTap: () => openIt(d),
      ),
      onOpen: openIt,
      emptyTitle: l10n.bo17_empty,
      emptyMessage: l10n.mst_empty_message,
      emptyActionLabel: l10n.mst_create,
      onEmptyAction: () => openMasterPage(context, const DriverFormScreen()),
      loadingTitle: l10n.bo17_loading,
      errorTitle: l10n.bo17_error,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(driversProvider),
      successTitle: l10n.bo17_success,
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const DriverFormScreen()),
      countLabel: l10n.list_rows,
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.driver});

  final DriverInfo driver;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final name = driver.name(arabic: context.isArabic);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            TTAvatar(initials: initialsOf(name)),
            const TTGap.sm(axis: Axis.horizontal),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(name, style: context.text.titleSmall),
                  Text(driver.id, style: context.text.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const TTGap.sm(),
        TTStatusPill(
          style: driverStatusStyle(driver.status),
          label: masterStatusLabel(driver.status, l10n),
        ),
        const TTGap.sm(),
        TTListTile(
          title: driver.phone,
          trailing: Text('${l10n.drv_licence} ${driver.licenceExpiryDays}'),
        ),
      ],
    );
  }
}

/// BO-18 Driver Detail: back arrow + H1, avatar card, overview rows,
/// availability calendar, activity timeline. No cartoon hero grid (13 §2).
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
      return const TTScaffold(body: TTSkeletonList());
    }
    final now = DateTime.now();
    final name = driver.name(arabic: context.isArabic);
    final commitments =
        demoCommitments(driver.id, now.year, now.month);
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
                DriverFormScreen(existing: driver),
              ),
              child: Text(l10n.detail_edit),
            ),
            TextButton(
              onPressed: () => showTTToast(
                context,
                message: '${l10n.detail_assign} · $name',
              ),
              child: Text(l10n.detail_assign),
            ),
          ],
        ),
        const TTGap.md(),
        TTCard(
          child: Row(
            children: [
              TTAvatar(initials: initialsOf(name)),
              const TTGap.md(axis: Axis.horizontal),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: context.text.titleMedium),
                    Text(driver.id, style: context.text.bodySmall),
                    const TTGap.xs(),
                    StatusChip(
                      style: driverStatusStyle(driver.status),
                      label: masterStatusLabel(driver.status, l10n),
                    ),
                  ],
                ),
              ),
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
                  leading: Icon(AppIcons.iconFor(AppIcons.user, context)),
                  title: driver.phone,
                ),
                const TTDivider(),
                TTListTile(
                  leading: Icon(AppIcons.iconFor(AppIcons.calendar, context)),
                  title: '${l10n.drv_licence} ${driver.licenceExpiryDays}',
                ),
                const TTDivider(),
                TTListTile(
                  leading:
                      Icon(AppIcons.iconFor(AppIcons.inspection, context)),
                  title: l10n.detail_documents,
                  subtitle: masterStatusLabel(driver.status, l10n),
                ),
              ],
            ),
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.detail_availability,
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
        const TTGap.lg(),
        TTSection(
          title: l10n.detail_activity,
          child: TTTimeline(
            entries: [
              TTTimelineEntry(
                title: '${l10n.drv_licence} ${driver.licenceExpiryDays}',
                color: context.status.active,
              ),
              TTTimelineEntry(
                title: masterStatusLabel(driver.status, l10n),
                subtitle: driver.phone,
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
          Row(
            children: [
              TTAvatar(initials: initialsOf(name), small: true),
              const TTGap.sm(axis: Axis.horizontal),
              Expanded(
                child: Text(name, style: context.text.titleMedium),
              ),
            ],
          ),
          const TTGap.sm(),
          StatusChip(
            style: driverStatusStyle(driver.status),
            label: masterStatusLabel(driver.status, l10n),
          ),
          const TTGap.sm(),
          Text(
            '${l10n.drv_licence} ${driver.licenceExpiryDays}',
            style: context.text.bodyMedium,
          ),
          const TTGap.md(),
          TTButton(
            label: l10n.detail_edit,
            onPressed: () => openMasterPage(
              context,
              DriverFormScreen(existing: driver),
            ),
          ),
        ],
      ),
    );
    final caption = '${l10n.drv_licence} ${driver.licenceExpiryDays}';
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
            number: driver.phone,
            caption: caption,
            ctaLabel: l10n.detail_edit,
            onCta: () => openMasterPage(
              context,
              DriverFormScreen(existing: driver),
            ),
          ),
        );
      },
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
