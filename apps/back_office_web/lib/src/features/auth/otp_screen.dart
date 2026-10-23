import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';
import '../../routes.dart';
import 'auth_chrome.dart';

/// Localized strings for [OtpScreen] — built from `context.l10n` at the
/// call site (R3 §3 `auth_otp_*`), mirroring `MfaStrings`/`AuthStrings`.
class OtpStrings {
  const OtpStrings({
    required this.title,
    required this.hint,
    required this.verify,
    required this.resend,
    required this.invalid,
  });

  final String title;
  final String hint;
  final String verify;
  final String resend;
  final String invalid;
}

/// BO-03 OTP Verification (contracts §1: replaces the /mfa flow for
/// everyone — TOTP/MFA concept stays for admin/supervisor/finance, same
/// screen): six boxes, VERIFY, resend, change-login-method → BO-01.
/// Any 6-digit code is accepted in demo builds.
///
/// The Figma resend-cooldown + expiry footnote have no ARB keys — resend is
/// always available in demo (return notes).
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.strings, required this.onVerified});

  final OtpStrings strings;
  final VoidCallback onVerified;

  @override
  ConsumerState<OtpScreen> createState() => _OtpState();
}

class _OtpState extends ConsumerState<OtpScreen> {
  late final List<TextEditingController> _boxes;
  late final List<FocusNode> _nodes;
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    _boxes = List.generate(6, (_) => TextEditingController());
    _nodes = List.generate(6, (_) => FocusNode());
    for (var i = 0; i < 6; i++) {
      final index = i;
      _boxes[i].addListener(() => _onBoxChanged(index, _boxes[index].text));
    }
  }

  @override
  void dispose() {
    for (final c in _boxes) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _code => _boxes.map((c) => c.text.trim()).join();

  void _verify() {
    final ok = AppFlags.isDemoBuild && RegExp(r'^[0-9]{6}$').hasMatch(_code);
    if (ok) {
      widget.onVerified();
      return;
    }
    setState(() => _invalid = true);
  }

  void _onBoxChanged(int index, String value) {
    setState(() => _invalid = false);
    if (value.isNotEmpty && index < 5) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    if (_code.length == 6) _verify();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final l10n = context.l10n;
    return AuthChrome(
      title: s.title,
      subtitle: s.hint,
      form: AuthDemoState(
        screenId: 'bo03',
        emptyTitle: l10n.bo03_empty,
        emptyMessage: l10n.mst_empty_message,
        loadingTitle: l10n.bo03_loading,
        errorTitle: l10n.bo03_error,
        retryLabel: l10n.mst_retry,
        successTitle: l10n.bo03_success,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_invalid) TTBanner(message: s.invalid),
            if (_invalid) const TTGap.md(),
            Row(
              children: [
                for (var i = 0; i < 6; i++) ...[
                  if (i > 0) const TTGap.sm(axis: Axis.horizontal),
                  Expanded(
                    child: TTTextField(
                      controller: _boxes[i],
                      keyboardType: TextInputType.number,
                      textInputAction: i == 5
                          ? TextInputAction.done
                          : TextInputAction.next,
                      onSubmitted: (_) => _verify(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const TTGap.lg(),
            TTButton(label: s.verify, onPressed: _verify),
            const TTGap.sm(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    for (final c in _boxes) {
                      c.clear();
                    }
                    _nodes.first.requestFocus();
                  },
                  child: Text(s.resend),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(sessionProvider.notifier).state = null;
                    ref
                        .read(sessionPendingMfaProvider.notifier)
                        .state = true;
                    context.go(AppRoutes.login);
                  },
                  child: Text(l10n.loginSignIn),
                ),
              ],
            ),
            if (AppFlags.isDemoBuild) ...[
              const TTGap.sm(),
              Text(
                l10n.mfa_note_demo,
                style: context.text.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      footer: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [AuthLocaleRow()],
      ),
    );
  }
}
