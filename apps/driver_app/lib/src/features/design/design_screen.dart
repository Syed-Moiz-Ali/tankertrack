import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

/// /design storybook: every TT* component, localized, in the active
/// surface theme (driver here). Goldens cover all 12 theme variants.
class DesignScreen extends StatelessWidget {
  const DesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DesignCatalogue(
      strings: DesignStrings(
        components: l10n.designComponents,
        buttons: l10n.designButtons,
        primary: l10n.designPrimary,
        secondary: l10n.designSecondary,
        tertiary: l10n.designTertiary,
        fields: l10n.designFields,
        searchHint: l10n.designSearchHint,
        chips: l10n.designChips,
        quantities: l10n.designQuantities,
        sync: l10n.designSync,
        cards: l10n.designCards,
        banners: l10n.designBanners,
        states: l10n.designStates,
        emptyTitle: l10n.designEmptyTitle,
        emptyMessage: l10n.designEmptyMessage,
        errorTitle: l10n.designErrorTitle,
        errorMessage: l10n.designErrorMessage,
        retry: l10n.retry,
        flow: l10n.designFlow,
      ),
    );
  }
}
