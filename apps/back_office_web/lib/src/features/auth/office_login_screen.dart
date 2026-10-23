import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';
import '../../routes.dart';
import 'auth_chrome.dart';

// Demo credential pair (values live in variables — never in Text — so the
// raw-string lint stays clean; labels come from l10n).
const _demoId = 'dispatch@demo.ae';
const _demoSecret = 'demo1234';

/// BO-01 Back Office Login (13 §6): split layout — calm brand panel with the
/// tanker silhouette mark + clean form (sign in, forgot password, OTP
/// entry, demo helper in demo builds only).
///
/// Figma elements without ARB keys (company field, Remember-me, SSO buttons,
/// support footer) are omitted — see return notes for the missing-key list.
class OfficeLoginScreen extends ConsumerStatefulWidget {
  const OfficeLoginScreen({super.key});

  @override
  ConsumerState<OfficeLoginScreen> createState() => _OfficeLoginState();
}

class _OfficeLoginState extends ConsumerState<OfficeLoginScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _secret = TextEditingController();
  bool _obscured = true;
  bool _failed = false;
  bool _busy = false;

  @override
  void dispose() {
    _id.dispose();
    _secret.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _busy = true;
      _failed = false;
    });
    final result = await ref.read(authRepositoryProvider).login(
          identifier: _id.text,
          secret: _secret.text,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold((Session session) {
      if (session.role == Role.driver) {
        setState(() => _failed = true);
        return;
      }
      // R3 §1: every login verifies BO-03 OTP (TOTP concept stays for
      // admin/supervisor/finance, same screen), then picks a workspace.
      ref.read(sessionPendingMfaProvider.notifier).state = true;
      ref.read(sessionRoleChosenProvider.notifier).state = false;
      ref.read(sessionProvider.notifier).state = session;
    }, (Object error) {
      setState(() => _failed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AuthChrome(
      title: l10n.loginTitle,
      subtitle: l10n.login_welcome,
      form: AuthDemoState(
        screenId: 'bo01',
        emptyTitle: l10n.bo01_empty,
        emptyMessage: l10n.mst_empty_message,
        loadingTitle: l10n.bo01_loading,
        errorTitle: l10n.bo01_error,
        retryLabel: l10n.mst_retry,
        successTitle: l10n.bo01_success,
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_failed) TTBanner(message: l10n.loginFailed),
              if (_failed) const TTGap.md(),
              TTTextField(
                label: l10n.loginEmailLabel,
                hint: l10n.loginEmailHint,
                controller: _id,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? l10n.requiredField : null,
              ),
              const TTGap.md(),
              TTTextField(
                label: l10n.loginPasswordLabel,
                controller: _secret,
                obscureText: _obscured,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                validator: (String? v) =>
                    (v == null || v.isEmpty) ? l10n.requiredField : null,
                suffixIcon: IconButton(
                  icon: Icon(
                    AppIcons.iconFor(
                      _obscured ? AppIcons.visibility : AppIcons.visibilityOff,
                      context,
                    ),
                  ),
                  onPressed: () => setState(() => _obscured = !_obscured),
                ),
              ),
              const TTGap.lg(),
              TTButton(
                label: l10n.loginSignIn,
                onPressed: _busy ? null : _submit,
                loading: _busy,
              ),
              const TTGap.sm(),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.forgotPassword),
                  child: Text(l10n.auth_forgot_title),
                ),
              ),
            ],
          ),
        ),
      ),
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          DemoAuthHelper(
            demoId: _demoId,
            demoSecret: _demoSecret,
            onFill: (String id, String secret) {
              _id.text = id;
              _secret.text = secret;
            },
          ),
          const TTGap.sm(),
          const AuthLocaleRow(),
        ],
      ),
    );
  }
}
