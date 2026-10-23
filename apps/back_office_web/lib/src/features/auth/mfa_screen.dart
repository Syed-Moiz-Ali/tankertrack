import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Localized strings for [MfaScreen] — built from `context.l10n` at the
/// call site, mirroring `AuthStrings` / `DesignStrings`.
class MfaStrings {
  const MfaStrings({
    required this.title,
    required this.hint,
    required this.codeLabel,
    required this.verify,
    required this.invalid,
    required this.noteDemo,
  });

  final String title;
  final String hint;
  final String codeLabel;
  final String verify;
  final String invalid;
  final String noteDemo;
}

/// Pending-MFA gate (P1 contracts §1): any 6-digit code is accepted in demo
/// builds and completes the session via [onVerified]; anything else — and
/// every attempt in non-demo builds (real TOTP is P11) — shows the error
/// state. Built ONLY from TT* components.
class MfaScreen extends StatefulWidget {
  const MfaScreen({super.key, required this.strings, required this.onVerified});

  final MfaStrings strings;
  final VoidCallback onVerified;

  @override
  State<MfaScreen> createState() => _MfaScreenState();
}

class _MfaScreenState extends State<MfaScreen> {
  final _code = TextEditingController();
  bool _invalid = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _verify() {
    final ok = AppFlags.isDemoBuild &&
        RegExp(r'^[0-9]{6}$').hasMatch(_code.text.trim());
    if (ok) {
      widget.onVerified();
      return;
    }
    setState(() => _invalid = true);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    return TTScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.tokens.contentNarrow),
          child: ListView(
            shrinkWrap: true,
            children: [
              const TTGap.xxl(),
              Text(
                s.title,
                style: context.text.displaySmall,
                textAlign: TextAlign.center,
              ),
              const TTGap.xs(),
              Text(
                s.hint,
                style: context.text.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const TTGap.xl(),
              if (_invalid)
                TTBanner(message: s.invalid, kind: TTBannerKind.critical),
              if (_invalid) const TTGap.md(),
              TTTextField(
                label: s.codeLabel,
                controller: _code,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _verify(),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
              ),
              const TTGap.lg(),
              TTButton(label: s.verify, onPressed: _verify),
              const TTGap.md(),
              Text(
                s.noteDemo,
                style: context.text.bodySmall,
                textAlign: TextAlign.center,
              ),
              const TTGap.xxl(),
            ],
          ),
        ),
      ),
    );
  }
}
