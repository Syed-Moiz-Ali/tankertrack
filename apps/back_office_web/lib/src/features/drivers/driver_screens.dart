import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

AppIcon _dutyIcon(String status) => switch (status) {
      'onDuty' => AppIcons.check,
      'offDuty' => AppIcons.offline,
      'leave' => AppIcons.calendar,
      _ => AppIcons.incident,
    };

StatusStyle driverStatusStyle(String status) => switch (status) {
      'onDuty' => StatusStyle.active,
      'offDuty' => StatusStyle.offline,
      'leave' => StatusStyle.waiting,
      _ => StatusStyle.critical,
    };

String _initials(String name) {
  final parts = name.split(' ').where((p) => p.isNotEmpty);
  return parts.take(2).map((p) => p.substring(0, 1)).join();
}

/// Drivers master: R1 media-card grid + R2/R3 detail + form.
class DriverListScreen extends ConsumerWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final drivers = ref.watch(driversProvider);
    return MasterAsyncView<DriverInfo>(
      value: drivers,
      emptyTitle: l10n.mst_empty_title,
      emptyMessage: l10n.mst_empty_message,
      errorTitle: l10n.mst_error_title,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(driversProvider),
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const DriverFormScreen()),
      data: (items) {
        final statuses = {
          for (final d in items) d.status,
        }.toList()
          ..sort();
        return MasterGridView(
          title: l10n.nav_drivers,
          searchHint: l10n.mst_search,
          allLabel: l10n.mst_all,
          categories: [
            for (final s in statuses)
              MasterCategory(
                icon: _dutyIcon(s),
                label: masterStatusLabel(s, l10n),
                value: s,
              ),
          ],
          rows: [
            for (final d in items)
              MasterCardData(
                title: d.name(arabic: context.isArabic),
                subtitle: '${d.id} · ${d.phone}',
                figure: '${l10n.drv_licence} ${d.licenceExpiryDays}',
                badge: masterStatusLabel(d.status, l10n),
                status: d.status,
                image:
                    SvgPicture.asset(AppAssets.driver, fit: BoxFit.contain),
                onTap: () => context.go(AppRoutes.driverDetail(d.id)),
              ),
          ],
          countLabel: l10n.list_rows,
          emptyTitle: l10n.mst_empty_title,
          emptyMessage: l10n.mst_empty_message,
          createLabel: l10n.mst_create,
          onCreate: () => openMasterPage(context, const DriverFormScreen()),
        );
      },
    );
  }
}

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
              TTAvatar(initials: _initials(name)),
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
        const TTGap.md(),
        TTImageGrid(
          images: illustrationCells(const [
            AppAssets.driver,
            AppAssets.tanker,
            AppAssets.emptyTasks,
            AppAssets.depot,
            AppAssets.emptyMap,
          ]),
          showAllLabel: l10n.detail_photos,
          onShowAll: () => openIllustrationGallery(
            context,
            title: l10n.detail_photos,
            uris: const [
              AppAssets.driver,
              AppAssets.tanker,
              AppAssets.emptyTasks,
              AppAssets.depot,
              AppAssets.emptyMap,
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
              TTAvatar(initials: _initials(name), small: true),
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
