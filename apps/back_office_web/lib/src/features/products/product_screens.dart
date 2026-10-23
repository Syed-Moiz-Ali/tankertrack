import 'package:data/data.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../data_providers.dart';
import '../masters/master_list_view.dart';

/// Products master: list + create/edit form (no detail per contract §1).
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final products = ref.watch(productsProvider);
    return MasterAsyncView<Product>(
      value: products,
      appBarTitle: l10n.nav_products,
      emptyTitle: l10n.mst_empty_title,
      emptyMessage: l10n.mst_empty_message,
      errorTitle: l10n.mst_error_title,
      retryLabel: l10n.mst_retry,
      onRetry: () => ref.invalidate(productsProvider),
      createLabel: l10n.mst_create,
      onCreate: () => openMasterPage(context, const ProductFormScreen()),
      data: (items) => MasterListView(
        title: l10n.nav_products,
        searchHint: l10n.mst_search,
        allLabel: l10n.mst_all,
        countLabel: l10n.list_rows,
        emptyTitle: l10n.mst_empty_title,
        emptyMessage: l10n.mst_empty_message,
        createLabel: l10n.mst_create,
        onCreate: () => openMasterPage(context, const ProductFormScreen()),
        rows: [
          for (final p in items)
            MasterRowData(
              title: p.name(arabic: context.isArabic),
              subtitle: '${l10n.prod_unit} ${p.unit}',
              status: p.active ? l10n.mst_active : l10n.mst_inactive,
              chip: StatusChip(
                style: p.active ? StatusStyle.completed : StatusStyle.offline,
                label: p.active ? l10n.mst_active : l10n.mst_inactive,
              ),
              onTap: () => openMasterPage(
                context,
                ProductFormScreen(existing: p),
              ),
            ),
        ],
      ),
    );
  }
}

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, this.existing});

  final Product? existing;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductFormScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nameEn;
  late final TextEditingController _nameAr;
  late final TextEditingController _unit;
  late bool _active;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameEn = TextEditingController(text: e?.nameEn ?? '');
    _nameAr = TextEditingController(text: e?.nameAr ?? '');
    _unit = TextEditingController(text: e?.unit ?? '');
    _active = e?.active ?? true;
  }

  @override
  void dispose() {
    _nameEn.dispose();
    _nameAr.dispose();
    _unit.dispose();
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
                label: l10n.prod_unit,
                controller: _unit,
                validator: required,
              ),
              const TTGap.md(),
              TTDropdown<bool>(
                label: l10n.prod_active,
                value: _active,
                items: [
                  TTDropdownItem(
                    value: true,
                    label: l10n.mst_active,
                  ),
                  TTDropdownItem(
                    value: false,
                    label: l10n.mst_inactive,
                  ),
                ],
                onChanged: (v) => setState(() => _active = v ?? _active),
              ),
              const TTGap.lg(),
              TTButton(
                label: l10n.mst_save,
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  final svc = ref.read(masterDataProvider);
                  final id = widget.existing?.id ??
                      svc.newIdFor('DSL-', 'products', 'product_id');
                  svc.saveProduct(
                    Product(
                      id: id,
                      nameEn: _nameEn.text.trim(),
                      nameAr: _nameAr.text.trim(),
                      unit: _unit.text.trim(),
                      active: _active,
                    ),
                  );
                  ref.invalidate(productsProvider);
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
