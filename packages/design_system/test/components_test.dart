import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// P1b Airbnb-reference component interaction tests (ui-builder slice):
/// tab select, carousel scroll, media card tap, profile sheet opens,
/// segmented counts — plus RTL pump smoke coverage.
void main() {
  Widget harness(Widget child) {
    return MaterialApp(
      theme: AppTheme.build(
        surface: AppSurface.web,
        brightness: Brightness.light,
        arabic: false,
      ),
      home: Scaffold(body: Center(child: child)),
    );
  }

  Widget profileButton({
    ValueChanged<ThemeMode>? onTheme,
    ValueChanged<Locale>? onLocale,
    ValueChanged<String>? onRole,
    VoidCallback? onSignOut,
  }) {
    return TTProfileMenuButton(
      avatarLabel: 'OP',
      sheetTitle: 'Profile',
      themeMode: ThemeMode.light,
      onTheme: onTheme ?? (_) {},
      lightLabel: 'Light',
      darkLabel: 'Dark',
      systemLabel: 'System',
      locale: const Locale('en'),
      onLocale: onLocale ?? (_) {},
      englishLabel: 'English',
      arabicLabel: 'Arabic',
      roleEntries: const [
        TTMenuRole(value: 'dispatcher', label: 'Dispatcher'),
      ],
      currentRole: 'dispatcher',
      onRole: onRole ?? (_) {},
      demoRoleLabel: 'Demo role',
      signOutLabel: 'Sign out',
      onSignOut: onSignOut ?? () {},
      profileLabel: 'Omar Planner',
    );
  }

  testWidgets('TTTopNav selects tabs', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      harness(
        StatefulBuilder(
          builder: (context, setState) => TTTopNav(
            tabs: const [
              TTNavTabData(label: 'Today', icon: AppIcons.dashboard),
              TTNavTabData(label: 'Fleet', icon: AppIcons.truck),
            ],
            selectedIndex: selected,
            onSelect: (i) => setState(() => selected = i),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fleet'));
    await tester.pumpAndSettle();
    expect(selected, 1);
  });

  testWidgets('TTSegmentedTabs shows counts and reports selection',
      (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      harness(
        StatefulBuilder(
          builder: (context, setState) => TTSegmentedTabs(
            tabs: const [
              TTCountTab(label: 'Now', count: 3),
              TTCountTab(label: 'Upcoming', count: 12),
            ],
            selected: selected,
            onSelect: (i) => setState(() => selected = i),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    await tester.tap(find.text('Upcoming'));
    await tester.pumpAndSettle();
    expect(selected, 1);
  });

  testWidgets('TTCategoryBar selects items', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      harness(
        StatefulBuilder(
          builder: (context, setState) => TTCategoryBar(
            items: const [
              TTCategoryItem(icon: AppIcons.truck, label: 'Tankers'),
              TTCategoryItem(icon: AppIcons.depot, label: 'Depots'),
            ],
            selected: selected,
            onSelect: (i) => setState(() => selected = i),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Depots'));
    await tester.pumpAndSettle();
    expect(selected, 1);
  });

  testWidgets('TTCarousel next arrow scrolls forward', (tester) async {
    // Desktop viewport: arrows are a desktop affordance (hidden on touch).
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      harness(
        SizedBox(
          width: 1200,
          child: TTCarousel(
            itemWidth: 200,
            children: [
              for (var i = 0; i < 8; i++)
                SizedBox(width: 200, height: 120, child: Text('Stop $i')),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    ScrollableState scrollable() =>
        tester.state<ScrollableState>(find.byType(Scrollable).first);
    expect(scrollable().position.pixels, 0);
    await tester.tap(find.byType(TTIconCircleButton).last);
    await tester.pumpAndSettle();
    expect(scrollable().position.pixels, greaterThan(0));
  });

  testWidgets('TTCarousel hides arrows on narrow viewports', (tester) async {
    await tester.pumpWidget(
      harness(
        SizedBox(
          width: 320,
          child: TTCarousel(
            itemWidth: 200,
            children: [
              for (var i = 0; i < 4; i++)
                SizedBox(width: 200, height: 120, child: Text('Stop $i')),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TTIconCircleButton), findsNothing);
  });

  testWidgets('TTMediaCard tap + save', (tester) async {
    var tapped = false;
    var savedTap = false;
    await tester.pumpWidget(
      harness(
        SizedBox(
          width: 300,
          child: TTMediaCard(
            title: 'T-214 Riyadh',
            subtitle: '4,000 IG',
            figure: 'SAR 12,400',
            badge: 'Available',
            onTap: () => tapped = true,
            onSave: () => savedTap = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('T-214 Riyadh'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
    await tester.tap(find.byType(TTIconCircleButton));
    await tester.pumpAndSettle();
    expect(savedTap, isTrue);
  });

  testWidgets('TTProfileMenuButton opens grabber sheet', (tester) async {
    var signedOut = false;
    await tester.pumpWidget(harness(profileButton(
      onSignOut: () => signedOut = true,
    )));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsNothing);
    await tester.tap(find.text('OP'));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Sign out'), 200);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    expect(signedOut, isTrue);
  });

  testWidgets('p1b components pump in RTL', (tester) async {
    // Tall viewport so every ListView child builds without scrolling.
    tester.view.physicalSize = const Size(800, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          surface: AppSurface.web,
          brightness: Brightness.light,
          arabic: true,
        ),
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: ListView(
              children: [
                TTTopNav(
                  tabs: const [
                    TTNavTabData(label: 'Today', icon: AppIcons.dashboard),
                    TTNavTabData(label: 'Fleet', icon: AppIcons.truck),
                  ],
                  selectedIndex: 0,
                  onSelect: (_) {},
                ),
                TTCarousel(
                  itemWidth: 200,
                  children: const [
                    Text('Stop 1'),
                    Text('Stop 2'),
                  ],
                ),
                const TTImageGrid(
                  images: [Text('A'), Text('B'), Text('C')],
                  showAllLabel: 'Show all',
                ),
                const TTSectionHeader(title: 'Fleet today'),
                TTStickyBottomBar(
                  number: '48,200 IG',
                  ctaLabel: 'Dispatch',
                  onCta: () {},
                ),
                const TTStackedBar(
                  segments: [
                    TTBarSegment(
                      label: 'Done',
                      value: 60,
                      style: StatusStyle.completed,
                    ),
                    TTBarSegment(
                      label: 'Active',
                      value: 40,
                      style: StatusStyle.active,
                    ),
                  ],
                ),
                const TTDonut(
                  segments: [
                    TTBarSegment(
                      label: 'Diesel',
                      value: 70,
                      style: StatusStyle.completed,
                    ),
                    TTBarSegment(
                      label: 'Petrol',
                      value: 30,
                      style: StatusStyle.active,
                    ),
                  ],
                ),
                const TTSparkline(values: [1, 3, 2, 5]),
                TTBottomTabBar(
                  tabs: const [
                    TTBottomTab(icon: AppIcons.dashboard, label: 'Today'),
                    TTBottomTab(icon: AppIcons.user, label: 'Profile'),
                  ],
                  index: 0,
                  onTap: (_) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TTTopNav), findsOneWidget);
    expect(find.byType(TTCarousel), findsOneWidget);
    expect(find.byType(TTImageGrid), findsOneWidget);
    expect(find.byType(TTSectionHeader), findsOneWidget);
    expect(find.byType(TTStackedBar), findsOneWidget);
    expect(find.byType(TTDonut), findsOneWidget);
    expect(find.byType(TTBottomTabBar), findsOneWidget);
  });
}
