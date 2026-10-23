import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../routes.dart';
import 'auth_chrome.dart';

/// BO-02 Forgot Password (Figma copy verbatim via `auth_forgot_*`):
/// work-email field → SEND RESET LINK → non-enumerating confirmation;
/// Back-to-login link → BO-01. Split layout via [AuthChrome].
///
/// The Figma rate-limit footnote has no ARB key — omitted (return notes).
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPasswordScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthChrome(
      title: l10n.auth_forgot_title,
      subtitle: l10n.auth_forgot_hint,
      form: AuthDemoState(
        screenId: 'bo02',
        emptyTitle: l10n.bo02_empty,
        emptyMessage: l10n.mst_empty_message,
        loadingTitle: l10n.bo02_loading,
        errorTitle: l10n.bo02_error,
        retryLabel: l10n.mst_retry,
        successTitle: l10n.bo02_success,
        child: _sent
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TTBanner(message: l10n.auth_forgot_sent),
                  const TTGap.lg(),
                  TTButton(
                    variant: TTButtonVariant.secondary,
                    label: l10n.loginSignIn,
                    onPressed: () => context.go(AppRoutes.login),
                  ),
                ],
              )
            : Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TTTextField(
                      label: l10n.loginEmailLabel,
                      hint: l10n.loginEmailHint,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _send(),
                      validator: (String? v) =>
                          (v == null || v.trim().isEmpty)
                              ? l10n.requiredField
                              : null,
                    ),
                    const TTGap.lg(),
                    TTButton(
                      label: l10n.auth_forgot_send,
                      onPressed: _send,
                    ),
                    const TTGap.sm(),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: Text(l10n.loginSignIn),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      footer: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [AuthLocaleRow()],
      ),
    );
  }

  void _send() {
    if (!(_form.currentState?.validate() ?? false)) return;
    // Non-enumerating by construction: identical confirmation regardless of
    // whether the account exists (Figma BO-02 outcome annotation).
    setState(() => _sent = true);
  }
}
