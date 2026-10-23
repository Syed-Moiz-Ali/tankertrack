import 'package:flutter/material.dart';

import '../context_ext.dart';
import '../icons.dart';

/// Generic dropdown (themed via InputDecoration + Menu themes).
class TTDropdown<T> extends StatelessWidget {
  const TTDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<TTDropdownItem<T>> items;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      icon: Icon(AppIcons.iconFor(AppIcons.chevronDown, context)),
      items: [
        for (final i in items)
          DropdownMenuItem<T>(value: i.value, child: Text(i.label)),
      ],
      onChanged: onChanged,
    );
  }
}

class TTDropdownItem<T> {
  const TTDropdownItem({required this.value, required this.label});
  final T value;
  final String label;
}

/// Sticky search bar (used above every list).
class TTSearchBar extends StatelessWidget {
  const TTSearchBar({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
  });

  final String hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hint,
      controller: controller,
      onChanged: onChanged,
      leading: Icon(AppIcons.iconFor(AppIcons.search, context)),
    );
  }
}

/// Pill filter row (single-select). Labels are localized by the caller.
class TTFilterPills extends StatelessWidget {
  const TTFilterPills({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String selected;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final o in options)
            Padding(
              padding: EdgeInsetsDirectional.only(end: context.tokens.spaceSm),
              child: FilterChip(
                label: Text(o),
                selected: o == selected,
                onSelected: (_) => onSelected(o),
              ),
            ),
        ],
      ),
    );
  }
}

/// Plain label chip (themed).
class TTChip extends StatelessWidget {
  const TTChip({super.key, required this.label, this.icon});

  final String label;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(label), avatar: icon);
  }
}
