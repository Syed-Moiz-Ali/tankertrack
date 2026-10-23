import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Localized labels for [LoginScreen]. The hosting app builds these from
/// `context.l10n` — the screen itself holds zero strings.
class AuthStrings {
  const AuthStrings({
    required this.welcome,
    required this.title,
    required this.subtitle,
    required this.idLabel,
    required this.idHint,
    required this.secretLabel,
    required this.signIn,
    required this.failed,
    required this.requiredField,
    required this.demoHint,
    required this.demoAccountsTitle,
    required this.appInitials,
  });

  final String welcome;
  final String title;
  final String subtitle;
  final String idLabel;
  final String idHint;
  final String secretLabel;
  final String signIn;
  final String failed;
  final String requiredField;
  final String demoHint;
  final String demoAccountsTitle;
  final String appInitials;
}

/// Sign-in screen built ONLY from TT* components + theme (08 §3).
/// Numeric [secretKeyboard] and PIN masking suit the driver app.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.strings,
    required this.onSignIn,
    required this.languageSwitch,
    this.secretKeyboard = TextInputType.visiblePassword,
    this.obscureSecret = true,
  });

  final AuthStrings strings;
  final Future<String?> Function(String id, String secret) onSignIn;
  final Widget languageSwitch;
  final TextInputType secretKeyboard;
  final bool obscureSecret;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _secret = TextEditingController();
  bool _loading = false;
  bool _failed = false;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureSecret;
  }

  @override
  void dispose() {
    _id.dispose();
    _secret.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _failed = false);
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _loading = true);
    final error = await widget.onSignIn(_id.text, _secret.text);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _failed = error != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final t = context.tokens;
    return TTScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: t.contentNarrow),
          child: Form(
            key: _form,
            child: ListView(
              shrinkWrap: true,
              children: [
                const TTGap.xl(),
                Center(
                  child: TTLogoMark(size: t.iconLg * 2),
                ),
                const TTGap.md(),
                Text(
                  s.welcome,
                  style: context.text.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const TTGap.xs(),
                Text(
                  s.subtitle,
                  style: context.text.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const TTGap.lg(),
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius:
                        BorderRadius.circular(t.radiusLarge),
                    border:
                        Border.all(color: context.colors.outlineVariant),
                    boxShadow: <BoxShadow>[context.shadows.float],
                  ),
                  padding: EdgeInsets.all(t.spaceXl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.title,
                        style: context.text.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const TTGap.md(),
                      if (_failed)
                        TTBanner(
                            message: s.failed,
                            kind: TTBannerKind.critical),
                      if (_failed) const TTGap.md(),
                      TTTextField(
                        label: s.idLabel,
                        hint: s.idHint,
                        controller: _id,
                        textInputAction: TextInputAction.next,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? s.requiredField
                                : null,
                      ),
                      const TTGap.md(),
                      TTTextField(
                        label: s.secretLabel,
                        controller: _secret,
                        obscureText: _obscured,
                        keyboardType: widget.secretKeyboard,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? s.requiredField : null,
                        suffixIcon: widget.obscureSecret
                            ? TTIconButton(
                                icon: Icon(AppIcons.iconFor(
                                  _obscured
                                      ? AppIcons.visibility
                                      : AppIcons.visibilityOff,
                                  context,
                                )),
                                onPressed: () =>
                                    setState(() => _obscured = !_obscured),
                              )
                            : null,
                      ),
                      const TTGap.lg(),
                      TTButton(
                        label: s.signIn,
                        loading: _loading,
                        onPressed: _loading ? null : _submit,
                      ),
                    ],
                  ),
                ),
                if (AppFlags.isDemoBuild && s.demoHint.isNotEmpty)
                  const TTGap.md(),
                if (AppFlags.isDemoBuild && s.demoHint.isNotEmpty)
                  TTCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          s.demoAccountsTitle,
                          style: context.text.titleSmall,
                        ),
                        const TTGap.xs(),
                        Text(
                          s.demoHint,
                          style: context.text.bodySmall,
                        ),
                      ],
                    ),
                  ),
                const TTGap.lg(),
                Center(child: widget.languageSwitch),
                const TTGap.xxl(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimal post-login landing for P0 (complete screen, not a TODO):
/// identity + role + links. P1 replaces the body with real dashboards.
class SignedInScreen extends StatelessWidget {
  const SignedInScreen({
    super.key,
    required this.greeting,
    required this.initials,
    required this.roleLabel,
    required this.roleStyle,
    required this.catalogueLabel,
    required this.signOutLabel,
    required this.onOpenCatalogue,
    required this.onSignOut,
  });

  final String greeting;
  final String initials;
  final String roleLabel;
  final StatusStyle roleStyle;
  final String catalogueLabel;
  final String signOutLabel;
  final VoidCallback onOpenCatalogue;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return TTScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TTAvatar(initials: initials),
            const TTGap.md(),
            Text(greeting, style: context.text.headlineSmall),
            const TTGap.sm(),
            StatusChip(style: roleStyle, label: roleLabel),
            const TTGap.lg(),
            TTButton(
              label: catalogueLabel,
              variant: TTButtonVariant.secondary,
              expanded: false,
              onPressed: onOpenCatalogue,
            ),
            const TTGap.sm(),
            TTButton(
              label: signOutLabel,
              variant: TTButtonVariant.tertiary,
              expanded: false,
              onPressed: onSignOut,
            ),
          ],
        ),
      ),
    );
  }
}
