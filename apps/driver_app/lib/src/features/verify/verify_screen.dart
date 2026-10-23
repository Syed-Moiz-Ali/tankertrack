import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';
import '../common/driver_screen_state.dart';

/// DR-02 Verify your account (R3 benchmark screen).
///
/// One decision per screen: enter the 6-digit code → pinned amber CTA
/// verifies. Copy from Figma via ARB only (08 §3): `dr_verify_*` for the
/// screen, `dr02_*` companions (TODO placeholders until l10n-rtl fills them),
/// `auth_otp_*`/`mfa_*` for the shared code-entry words. Anything Figma
/// shows without an ARB key is listed in the slice return, never hard-coded.
class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({
    super.key,
    this.status = DriverScreenStatus.success,
  });

  /// Companion-state override (tests / demo switcher). Production stays on
  /// `success` (the form); `verifiedProvider` is the real gate.
  final DriverScreenStatus status;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  final _code = TextEditingController();
  bool _invalid = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _submit() {
    if (_code.text.length != kVerifyCodeLength) {
      setState(() => _invalid = true);
      return;
    }
    setState(() => _invalid = false);
    ref.read(verifiedProvider.notifier).state = true;
  }

  void _resend() {
    _code.clear();
    setState(() => _invalid = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final online = ref.watch(connectionProvider);
    return TTScaffold(
      appBar: TTAppBar(title: l10n.dr_verify_title),
      banner: online
          ? null
          : TTBanner(message: l10n.offline, kind: TTBannerKind.offline),
      body: DriverScreenStateHost(
        status: widget.status,
        emptyTitle: l10n.dr_verify_title,
        emptyMessage: l10n.dr02_empty,
        errorTitle: l10n.dr_verify_title,
        errorMessage: l10n.dr02_error,
        retryLabel: l10n.retry,
        onRetry: _resend,
        successAnnouncement: l10n.dr02_success,
        child: ListView(
          children: [
            const TTGap.xl(),
            Row(
              children: [
                StatusChip(style: StatusStyle.active, label: l10n.online),
                const TTGap.md(axis: Axis.horizontal),
                SyncBadge(
                  state: online ? SyncState.synced : SyncState.pending,
                  label: online ? l10n.synced : l10n.pendingSync,
                ),
              ],
            ),
            const TTGap.lg(),
            Text(l10n.dr_verify_hint, style: context.text.bodyLarge),
            const TTGap.md(),
            TTTextField(
              label: l10n.mfa_code_label,
              controller: _code,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(kVerifyCodeLength),
              ],
            ),
            if (_invalid) const TTGap.sm(),
            if (_invalid)
              Text(
                l10n.auth_otp_invalid,
                style: context.text.bodyMedium
                    ?.copyWith(color: context.status.critical),
              ),
            const TTGap.md(),
            Text(l10n.mfa_note_demo, style: context.text.bodySmall),
            const TTGap.md(),
            TTButton(
              label: l10n.auth_otp_resend,
              variant: TTButtonVariant.tertiary,
              expanded: false,
              onPressed: _resend,
            ),
            const TTGap.xl(),
          ],
        ),
      ),
      bottomBar: TTStickyBottomBar(
        ctaLabel: l10n.auth_otp_verify,
        onCta: _submit,
      ),
    );
  }
}

/// Demo accepts any 6-digit code (mirrors the MFA demo rule).
const int kVerifyCodeLength = 6;
