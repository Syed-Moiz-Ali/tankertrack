import 'package:data/data.dart';
import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../../routes.dart';
import '../masters/master_list_view.dart';

/// Customers master: list + detail (sites tab) + create/edit form.
class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final customers = ref.watch(customersProvider);
    return MasterAsyncView<Customer>(
      value: customers,
      appBarTitle: l10n.nav_customers,
      emptyTitle: l10n.mst_empty_title,
      emptyMessage: l10n.mst_empty_message,
      errorTitle: l10n.mst_error_title,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(customersProvider),
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const CustomerFormScreen()),
      data: (items) => MasterListView(
        title: l10n.nav_customers,
        searchHint: l10n.mst_search,
        allLabel: l10n.mst_all,
        countLabel: l10n.list_rows,
        emptyTitle: l10n.mst_empty_title,
        emptyMessage: l10n.mst_empty_message,
        createLabel: l10n.mst_create,
        onCreate: () => openMasterPage(context, const CustomerFormScreen()),
        rows: [
          for (final c in items)
            MasterRowData(
              title: c.name(arabic: context.isArabic),
              subtitle: '${c.code} · ${c.phone}',
              status: c.status,
              chip: StatusChip(
                style: _style(c.status),
                label: masterStatusLabel(c.status, l10n),
              ),
              onTap: () => context.go(AppRoutes.customerDetail(c.id)),
            ),
        ],
      ),
    );
  }
}

StatusStyle _style(String status) => switch (status) {
      'active' => StatusStyle.completed,
      'credit_hold' => StatusStyle.waiting,
      _ => StatusStyle.offline,
    };

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
      return TTScaffold(
        appBar: masterDetailBar(context, l10n.nav_customers),
        body: const TTSkeletonList(),
      );
    }
    final mine = (sites.valueOrNull ?? const [])
        .where((s) => s.customerId == customerId)
        .toList();
    final arabic = context.isArabic;
    return TTScaffold(
      appBar: masterDetailBar(context, current.name(arabic: arabic)),
      body: DefaultTabController(
        length: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TTSection(
              title: current.code,
              child: TTCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${current.contact} · ${current.phone}',
                      style: context.text.bodyMedium,
                    ),
                    const TTGap.sm(),
                    StatusChip(
                      style: _style(current.status),
                      label: masterStatusLabel(current.status, l10n),
                    ),
                  ],
                ),
              ),
            ),
            const TTGap.md(),
            TabBar(
              tabs: [Tab(text: l10n.cust_sites_tab)],
            ),
            const TTGap.sm(),
            Expanded(
              child: TabBarView(
                children: [
                  ListView.separated(
                    itemCount: mine.length,
                    separatorBuilder: (_, __) => const TTGap.sm(),
                    itemBuilder: (context, i) {
                      final s = mine[i];
                      return TTCard(
                        padding: EdgeInsets.all(context.tokens.spaceSm),
                        child: TTListTile(
                          title: s.name(arabic: arabic),
                          subtitle:
                              '${l10n.site_lat} ${s.lat}, ${l10n.site_lng} ${s.lng} · '
                              '${l10n.site_geofence} ${s.geofenceM} · '
                              '${l10n.site_gate_hours} ${s.gateHours}',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const TTGap.sm(),
            TTCard(
              child: Text(
                l10n.cust_orders_hint,
                style: context.text.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
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
            ],
          ),
        ),
      ),
    );
  }
}
