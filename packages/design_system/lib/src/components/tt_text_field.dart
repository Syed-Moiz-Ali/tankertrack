import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../icons.dart';

/// Localized text field (look from InputDecorationTheme; large touch target
/// on driver surface via content padding).
class TTTextField extends StatelessWidget {
  const TTTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
    this.inputFormatters,
  });

  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines,
      enabled: enabled,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// IG quantity stepper field: presets + +/- steppers keep driver typing
/// minimal. Value is in IG (1 decimal display); parsing is locale-aware
/// (handled by the caller via l10n NumberFmt).
class TTNumberStepperField extends StatelessWidget {
  const TTNumberStepperField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.step = 100,
    this.min = 0,
    this.display,
  });

  final String label;
  final double value;
  final void Function(double) onChanged;
  final double step;
  final double min;
  final String? display;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: Row(
        children: [
          IconButton(
            icon: Icon(AppIcons.iconFor(AppIcons.remove, context)),
            onPressed: value - step < min ? null : () => onChanged(value - step),
          ),
          Expanded(
            child: Text(
              display ?? value.toStringAsFixed(1),
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Icon(AppIcons.iconFor(AppIcons.add, context)),
            onPressed: () => onChanged(value + step),
          ),
        ],
      ),
    );
  }
}
