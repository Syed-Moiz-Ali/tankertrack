import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

StatusStyle _customerStyle(String status) => switch (status) {
      'active' => StatusStyle.completed,
      'credit_hold' => StatusStyle.waiting,
      _ => StatusStyle.offline,
    };

/// BO-26 Customer Management (13 §6): typographic register rows/cards,
/// pill filters with real counts, List/Cards toggle, sheets +
/// Open-full-page. Detail carries the selected-customer panel over a
/// Dubai map snapshot (MiniMap) — no cartoon hero grid.
class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final arabic = context.isArabic;
    final siteCounts = <String, int>{};
    for (final s in ref.watch(sitesProvider).valueOrNull ?? const []) {
      siteCounts.update(s.customerId, (c) => c + 1, ifAbsent: () => 1);
    }
    void openIt(Customer c) => openDetail(
          context,
          title: c.name(arabic: arabic),
          preview: _Preview(customer: c, siteCount: siteCounts[c.id] ?? 0),
          fullRoute: AppRoutes.customerDetail(c.id),
          openFullLabel: l10n.sheet_open_full,
        );
    return R3ListView<Customer>(
      screenId: 'bo26',
      title: l10n.nav_customers,
      searchHint: l10n.mst_search,
      value: ref.watch(customersProvider),
      filterOf: (Customer c) => c.status,
      filterLabel: (String raw) => masterStatusLabel(raw, l10n),
      searchIn: (Customer c) =>
          '${c.nameEn} ${c.nameAr} ${c.code} ${c.id}'.toLowerCase(),
      row: (Customer c) => TTListRow(
        title: c.name(arabic: arabic),
        subtitle: '${c.code} · ${c.contact}',
        initials: initialsOf(c.name(arabic: arabic)),
        style: _customerStyle(c.status),
        pillLabel: masterStatusLabel(c.status, l10n),
        onTap: () => openIt(c),
      ),
      card: (Customer c) => TTEntityCard(
        title: c.name(arabic: arabic),
        subtitle: '${c.code} · ${c.contact} · ${c.phone}',
        details: ['${l10n.cust_sites_tab}: ${siteCounts[c.id] ?? 0}'],
        statusStyle: _customerStyle(c.status),
        statusLabel: masterStatusLabel(c.status, l10n),
        onTap: () => openIt(c),
      ),
      onOpen: openIt,
      emptyTitle: l10n.bo26_empty,
      emptyMessage: l10n.mst_empty_message,
      emptyActionLabel: l10n.mst_create,
      onEmptyAction: () => openMasterPage(context, const CustomerFormScreen()),
      loadingTitle: l10n.bo26_loading,
      errorTitle: l10n.bo26_error,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(customersProvider),
      successTitle: l10n.bo26_success,
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const CustomerFormScreen()),
      countLabel: l10n.list_rows,
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.customer, required this.siteCount});

  final Customer customer;
  final int siteCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final numbers = const NumberFmt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          customer.name(arabic: context.isArabic),
          style: context.text.titleMedium,
        ),
        Text(customer.code, style: context.text.bodySmall),
        const TTGap.sm(),
        TTStatusPill(
          style: _customerStyle(customer.status),
          label: masterStatusLabel(customer.status, l10n),
        ),
        const TTGap.sm(),
        TTListTile(
          title: customer.contact,
          subtitle: customer.phone,
          trailing: Text(numbers.integer(siteCount)),
        ),
      ],
    );
  }
}

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final customers = ref.watch(customersProvider);
    final sites = ref.watch(sitesProvider);
    final found = customers.valueOrNull?.where((c) => c.id == customerId);
    final current = found == null || found.isEmpty ? null : found.first;
    if (current == null) {
      return const TTScaffold(body: TTSkeletonList());
    }
    final mine = (sites.valueOrNull ?? const [])
        .where((s) => s.customerId == customerId)
        .toList();
    final arabic = context.isArabic;
    final name = current.name(arabic: arabic);
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
                CustomerFormScreen(existing: current),
              ),
              child: Text(l10n.detail_edit),
            ),
          ],
        ),
        const TTGap.md(),
        TTSection(
          title: l10n.detail_overview,
          child: TTCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TTListTile(
                  leading: Icon(AppIcons.iconFor(AppIcons.user, context)),
                  title: current.contact,
                  subtitle: current.phone,
                ),
                const TTDivider(),
                TTListTile(
                  leading: Icon(AppIcons.iconFor(AppIcons.info, context)),
                  title: current.code,
                  trailing: TTStatusPill(
                    style: _customerStyle(current.status),
                    label: masterStatusLabel(current.status, l10n),
                  ),
                ),
              ],
            ),
          ),
        ),
        const TTGap.lg(),
        TTCard(
          child: MiniMap(
            title: name,
            positions: [
              for (final s in mine)
                MapPosition(
                  id: s.id,
                  lat: s.lat,
                  lng: s.lng,
                  style: StatusStyle.active,
                  label: s.name(arabic: arabic),
                ),
            ],
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.cust_sites_tab,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final s in mine)
                Padding(
                  padding: EdgeInsets.only(
                    bottom: context.tokens.spaceSm,
                  ),
                  child: TTCard(
                    padding: EdgeInsets.all(context.tokens.spaceSm),
                    child: TTListTile(
                      title: s.name(arabic: arabic),
                      subtitle:
                          '${l10n.site_lat} ${s.lat}, ${l10n.site_lng} ${s.lng} · '
                          '${l10n.site_geofence} ${s.geofenceM} · '
                          '${l10n.site_gate_hours} ${s.gateHours}',
                    ),
                  ),
                ),
            ],
          ),
        ),
        const TTGap.lg(),
        TTSection(
          title: l10n.detail_activity,
          child: TTTimeline(
            entries: [
              for (final s in mine.take(5))
                TTTimelineEntry(
                  title: s.name(arabic: arabic),
                  subtitle:
                      '${l10n.site_geofence} ${s.geofenceM} · ${l10n.site_gate_hours} ${s.gateHours}',
                ),
            ],
          ),
        ),
        const TTGap.lg(),
        TTCard(
          child: Text(
            l10n.cust_orders_hint,
            style: context.text.bodyMedium,
            textAlign: TextAlign.center,
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
          Text(current.code, style: context.text.bodySmall),
          const TTGap.sm(),
          StatusChip(
            style: _customerStyle(current.status),
            label: masterStatusLabel(current.status, l10n),
          ),
          const TTGap.sm(),
          Text(
            '${current.contact} · ${current.phone}',
            style: context.text.bodyMedium,
          ),
          const TTGap.md(),
          TTButton(
            label: l10n.detail_edit,
            onPressed: () => openMasterPage(
              context,
              CustomerFormScreen(existing: current),
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
            number: current.code,
            caption: name,
            ctaLabel: l10n.detail_edit,
            onCta: () => openMasterPage(
              context,
              CustomerFormScreen(existing: current),
            ),
          ),
        );
      },
    );
  }
}

class CustomerFormScreen extends ConsumerStatefulWidget {
  const CustomerFormScreen({super.key, this.existing});

  final Customer? existing;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormState();
}

class _CustomerFormState extends ConsumerState<CustomerFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nameEn;
  late final TextEditingController _nameAr;
  late final TextEditingController _contact;
  late final TextEditingController _phone;
  late String _status;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameEn = TextEditingController(text: e?.nameEn ?? '');
    _nameAr = TextEditingController(text: e?.nameAr ?? '');
    _contact = TextEditingController(text: e?.contact ?? '');
    _phone = TextEditingController(text: e?.phone ?? '');
    _status = e?.status ?? 'active';
  }

  @override
  void dispose() {
    _nameEn.dispose();
    _nameAr.dispose();
    _contact.dispose();
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
                    label: l10n.mst_contact,
                    controller: _contact,
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
                      for (final s in ['active', 'credit_hold', 'inactive'])
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
                      final id = widget.existing?.id ??
                          svc.newIdFor('C-', 'customers', 'customer_id');
                      svc.saveCustomer(
                        Customer(
                          id: id,
                          code: widget.existing?.code ?? id,
                          nameEn: _nameEn.text.trim(),
                          nameAr: _nameAr.text.trim(),
                          contact: _contact.text.trim(),
                          phone: _phone.text.trim(),
                          status: _status,
                        ),
                      );
                      ref.invalidate(customersProvider);
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
