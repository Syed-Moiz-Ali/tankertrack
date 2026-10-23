import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:l10n/l10n.dart';

import '../../prefs.dart';
import '../../providers.dart';
import '../../ui/demo_state.dart';

/// R3 split-layout auth chrome (BO-01..04, 13 §6): calm brand panel
/// (tanker silhouette mark) + clean form. Narrow screens stack the panel
/// above the form.
///
/// Brand copy follows `context.l10n` only (08 §4): the Figma brand lines
/// (company name, tagline sentences, version footer) have no ARB keys yet —
/// see return notes. The panel therefore carries the mark, the localized
/// tagline and the silhouette until the l10n slice lands `auth_brand_*`.
class AuthChrome extends StatelessWidget {
  const AuthChrome({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    this.footer,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return TTScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.tokens.maxContentWidth),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final wide = constraints.maxWidth >=
                  context.tokens.breakpointTablet;
              final panel = _BrandPanel(narrow: !wide);
              final card = _FormCard(
                title: title,
                subtitle: subtitle,
                form: form,
                footer: footer,
              );
              if (!wide) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      panel,
                      const TTGap.lg(),
                      card,
                      const TTGap.xxl(),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: panel),
                    const TTGap.xl(axis: Axis.horizontal),
                    Expanded(child: card),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Brand panel: mark + localized tagline + tanker silhouette (13 §8:
/// recolor via tokens; no cartoon grids on cards).
class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.narrow});

  final bool narrow;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TTCard(
      radius: context.tokens.radiusLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const TTLogoMark(),
          const TTGap.md(),
          Text(l10n.loginSubtitle, style: context.text.titleLarge),
          const TTGap.xs(),
          Text(l10n.today_next_up, style: context.text.bodySmall),
          const TTGap.lg(),
          SvgPicture.asset(
            AppAssets.tanker,
            semanticsLabel: l10n.ill_tanker,
          ),
          const TTGap.md(),
          Text(l10n.shell_online, style: context.text.labelMedium),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.title,
    required this.subtitle,
    required this.form,
    required this.footer,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return TTCard(
      radius: context.tokens.radiusLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: context.text.headlineSmall),
          const TTGap.xs(),
          Text(subtitle, style: context.text.bodyMedium),
          const TTGap.lg(),
          form,
          if (footer != null) ...[
            const TTGap.lg(),
            footer!,
          ],
        ],
      ),
    );
  }
}

/// Demo-only helper (BO-01 brief: "demo helper demo-only"): fills the form
/// with demo credentials. No literals — values live in variables, labels in
/// l10n (`login_demo_accounts` + parameterized `loginDemoHint`).
class DemoAuthHelper extends ConsumerWidget {
  const DemoAuthHelper({
    super.key,
    required this.demoId,
    required this.demoSecret,
    required this.onFill,
  });

  final String demoId;
  final String demoSecret;
  final void Function(String id, String secret) onFill;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppFlags.isDemoBuild) return const SizedBox.shrink();
    final l10n = context.l10n;
    return TTCard(
      padding: EdgeInsets.all(context.tokens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.login_demo_accounts, style: context.text.titleSmall),
          const TTGap.xs(),
          Text(
            l10n.loginDemoHint(demoId, demoSecret),
            style: context.text.bodySmall,
          ),
          const TTGap.sm(),
          TTButton(
            variant: TTButtonVariant.secondary,
            label: l10n.login_demo_accounts,
            onPressed: () => onFill(demoId, demoSecret),
          ),
        ],
      ),
    );
  }
}

/// Compact language toggle row for auth screens (persisted via [AppPrefs]).
class AuthLocaleRow extends ConsumerWidget {
  const AuthLocaleRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return TTLanguageSwitch(
      current: ref.watch(localeProvider),
      englishLabel: l10n.langEnglish,
      arabicLabel: l10n.langArabic,
      compact: true,
      onChanged: (Locale next) async {
        ref.read(localeProvider.notifier).state = next;
        final prefs = await AppPrefs.load();
        await prefs.saveLocale(next);
      },
    );
  }
}

/// Demo-only companion-state preview for auth screens: forces the screen's
/// four `boXX_*` states (empty/loading/error with Figma copy, success as a
/// banner over the live form) without touching providers.
class AuthDemoState extends ConsumerWidget {
  const AuthDemoState({
    super.key,
    required this.screenId,
    required this.child,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.loadingTitle,
    required this.errorTitle,
    required this.retryLabel,
    required this.successTitle,
  });

  final String screenId;
  final Widget child;
  final String emptyTitle;
  final String emptyMessage;
  final String loadingTitle;
  final String errorTitle;
  final String retryLabel;
  final String successTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AppFlags.isDemoBuild) return child;
    final forced = ref.watch(demoScreenStateProvider(screenId));
    final body = switch (forced) {
      DemoScreenState.live => child,
      DemoScreenState.empty => TTEmptyState(
          title: emptyTitle,
          message: emptyMessage,
        ),
      DemoScreenState.loading => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loadingTitle, style: context.text.bodySmall),
            const TTGap.sm(),
            const TTSkeletonList(),
          ],
        ),
      DemoScreenState.error => TTErrorState(
          title: errorTitle,
          message: errorTitle,
          retryLabel: retryLabel,
        ),
      DemoScreenState.success => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TTBanner(message: successTitle),
            const TTGap.md(),
            child,
          ],
        ),
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        body,
        const TTGap.md(),
        DemoStatePanel(screenId: screenId),
      ],
    );
  }
}
