import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// THEME PROOF (acceptance test for UI centralization, `08` §5.4):
/// styling flows ONLY from the theme. Swap a theme entry → every widget
/// using it changes, with zero widget edits.
void main() {
  const swappedPrimary = Color(0xFF6D28D9);
  const swappedCompletedBg = Color(0xFF6D28D9);

  ThemeData baseTheme() => AppTheme.build(
        surface: AppSurface.web,
        brightness: Brightness.light,
        arabic: false,
      );

  ThemeData swappedTheme() {
    final base = baseTheme();
    return AppTheme.build(
      surface: AppSurface.web,
      brightness: Brightness.light,
      arabic: false,
      accentOverride: swappedPrimary,
    ).copyWith(
      extensions: <ThemeExtension<dynamic>>[
        base.extension<StatusColors>()!
            .copyWith(completedBg: swappedCompletedBg),
        base.extension<AppTokens>()!,
      ],
    );
  }

  Future<Color?> readPrimaryButtonColor(
    WidgetTester tester,
    ThemeData theme,
  ) async {
    // NOTE: MaterialApp animates theme changes (AnimatedTheme); settle so
    // reads observe the pumped theme, not the animation start value.
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          body: TTButton(label: 'X', onPressed: () {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final element = tester.element(find.byType(ElevatedButton));
    final style = ElevatedButtonTheme.of(element).style;
    return style?.backgroundColor?.resolve(<WidgetState>{});
  }

  Future<Color?> readStatusChipBg(
    WidgetTester tester,
    ThemeData theme,
    Color expected,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(
          body: StatusChip(style: StatusStyle.completed, label: 'X'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    Color? decorColor(Container c) {
      final d = c.decoration;
      if (d is BoxDecoration) return d.color;
      return null;
    }

    final match = find.byWidgetPredicate(
      (w) => w is Container && decorColor(w) == expected,
    );
    expect(match, findsOneWidget);
    final containers = tester.widgetList<Container>(
      find.descendant(
        of: find.byType(StatusChip),
        matching: find.byType(Container),
      ),
    );
    // Outer chip container carries the bg in its decoration (dot too, in fg).
    return containers
        .map(decorColor)
        .firstWhere((c) => c != null, orElse: () => null);
  }

  testWidgets('primary button color follows theme primary', (tester) async {
    expect(await readPrimaryButtonColor(tester, baseTheme()),
        AppPalette.accent);
    expect(await readPrimaryButtonColor(tester, swappedTheme()),
        swappedPrimary);
  });

  testWidgets('status chip bg follows StatusColors extension', (tester) async {
    expect(
      await readStatusChipBg(tester, baseTheme(), StatusColors.light.completedBg),
      StatusColors.light.completedBg,
    );
    expect(
      await readStatusChipBg(tester, swappedTheme(), swappedCompletedBg),
      swappedCompletedBg,
    );
  });

  testWidgets('button height follows surface theme (driver 56 / web 48)',
      (tester) async {
    Future<double> heightFor(AppSurface surface) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.build(
            surface: surface,
            brightness: Brightness.light,
            arabic: false,
          ),
          home: Scaffold(body: TTButton(label: 'X', onPressed: () {})),
        ),
      );
      return tester.getSize(find.byType(ElevatedButton)).height;
    }

    expect(await heightFor(AppSurface.driver),
        greaterThanOrEqualTo(AppTokens.base.touchDriver));
    expect(await heightFor(AppSurface.web),
        greaterThanOrEqualTo(AppTokens.base.touchWeb));
  });
}
