import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// R3 Calm Control component interaction tests (ui-components slice):
/// top bar, command palette, side sheet, split view, hero, stats, rows,
/// cards, dispatch, progress, bars, state host, dialogs — plus RTL smoke.
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

  Widget scaffolded(Widget child) {
    return MaterialApp(
      theme: AppTheme.build(
        surface: AppSurface.web,
        brightness: Brightness.light,
        arabic: false,
      ),
      home: Scaffold(body: child),
    );
  }

  TTTopBar topBar({
    ValueChanged<int>? onSelect,
    VoidCallback? onCommand,
    VoidCallback? onBell,
    VoidCallback? onProfile,
  }) {
    return TTTopBar(
      items: const [
        TTTopBarItem(label: 'Today', icon: AppIcons.dashboard),
        TTTopBarItem(label: 'Orders', icon: AppIcons.pod),
        TTTopBarItem(label: 'Live', icon: AppIcons.map),
      ],
      selectedIndex: 0,
      onSelect: onSelect ?? (_) {},
      commandHint: 'Search orders…',
      shortcutHint: 'Ctrl K',
      onCommand: onCommand ?? () {},
      notificationsLabel: 'Notifications',
      onNotifications: onBell ?? () {},
      profileLabel: 'OP',
      profileTooltip: 'Omar Planner',
      onProfile: onProfile ?? () {},
    );
  }

  testWidgets('TTTopBar selects items, fires command, bell and profile',
      (tester) async {
    var selected = 0;
    var commanded = false;
    var belled = false;
    var profiled = false;
    await tester.pumpWidget(
      harness(
        topBar(
          onSelect: (i) => selected = i,
          onCommand: () => commanded = true,
          onBell: () => belled = true,
          onProfile: () => profiled = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();
    expect(selected, 1);
    await tester.tap(find.text('Search orders…'));
    await tester.pumpAndSettle();
    expect(commanded, isTrue);
    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();
    expect(belled, isTrue);
    await tester.tap(find.text('OP'));
    await tester.pumpAndSettle();
    expect(profiled, isTrue);
  });

  testWidgets('TTTopBar shows notification dot when flagged', (tester) async {
    await tester.pumpWidget(
      harness(
        TTTopBar(
          items: const [TTTopBarItem(label: 'Today', icon: AppIcons.dashboard)],
          selectedIndex: 0,
          onSelect: (_) {},
          commandHint: 'Search…',
          shortcutHint: 'Ctrl K',
          onCommand: () {},
          hasNotifications: true,
          notificationsLabel: 'Notifications',
          onNotifications: () {},
          profileLabel: 'OP',
          profileTooltip: 'Omar',
          onProfile: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TTTopBar), findsOneWidget);
    expect(find.byTooltip('Notifications'), findsOneWidget);
  });

  testWidgets('TTCommandPalette filters, hints and reports selection',
      (tester) async {
    TTCommandItem? picked;
    await tester.pumpWidget(
      harness(
        SizedBox(
          width: 400,
          child: TTCommandPalette(
            hint: 'Search orders…',
            noResults: 'No results found.',
            shortcutHint: 'Enter to select',
            onSelect: (item) => picked = item,
            items: const [
              TTCommandItem(title: 'SO-260145', subtitle: 'ABC Trading'),
              TTCommandItem(title: 'Ahmed Khan', subtitle: 'Driver'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Enter to select'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'ahmed');
    await tester.pumpAndSettle();
    expect(find.text('Ahmed Khan'), findsOneWidget);
    expect(find.text('SO-260145'), findsNothing);
    await tester.tap(find.text('Ahmed Khan'));
    await tester.pumpAndSettle();
    expect(picked?.title, 'Ahmed Khan');
  });

  testWidgets('TTCommandPalette shows no-results state', (tester) async {
    await tester.pumpWidget(
      harness(
        SizedBox(
          width: 400,
          child: TTCommandPalette(
            hint: 'Search…',
            noResults: 'No results found.',
            shortcutHint: 'Enter to select',
            onSelect: (_) {},
            items: const [TTCommandItem(title: 'SO-260145')],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'zzz-no-match');
    await tester.pumpAndSettle();
    expect(find.text('No results found.'), findsOneWidget);
  });

  testWidgets('showTTCommandPalette returns the picked entry',
      (tester) async {
    TTCommandItem? picked;
    await tester.pumpWidget(
      scaffolded(
        Builder(
          builder: (context) => Center(
            child: SizedBox(
              width: 300,
              child: TTButton(
                label: 'Open',
                expanded: false,
                onPressed: () async {
                  picked = await showTTCommandPalette(
                    context,
                    hint: 'Search…',
                    noResults: 'Nothing.',
                    shortcutHint: 'Enter to select',
                    items: const [
                      TTCommandItem(title: 'SO-260145'),
                      TTCommandItem(title: 'Ahmed Khan'),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ahmed Khan'));
    await tester.pumpAndSettle();
    expect(picked?.title, 'Ahmed Khan');
  });

  testWidgets('TTSideSheet shows content and open-full-page action',
      (tester) async {
    var opened = false;
    await tester.pumpWidget(
      scaffolded(
        TTSideSheet(
          title: 'SO-260145',
          openFullPageLabel: 'Open full page',
          onOpenFullPage: () => opened = true,
          child: const Text('Sheet body'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('SO-260145'), findsOneWidget);
    expect(find.text('Sheet body'), findsOneWidget);
    await tester.tap(find.text('Open full page'));
    await tester.pumpAndSettle();
    expect(opened, isTrue);
  });

  testWidgets('showTTSideSheet slides in and closes', (tester) async {
    await tester.pumpWidget(
      scaffolded(
        Builder(
          builder: (context) => Center(
            child: SizedBox(
              width: 300,
              child: TTButton(
                label: 'Open sheet',
                expanded: false,
                onPressed: () => showTTSideSheet(
                  context,
                  title: 'SO-260145',
                  child: const Text('Sheet body'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet body'), findsOneWidget);
    await tester.tap(find.byIcon(AppIcons.iconFor(AppIcons.close, tester.element(find.text('Sheet body')))));
    await tester.pumpAndSettle();
    expect(find.text('Sheet body'), findsNothing);
  });

  testWidgets('TTSplitView shows both panes when wide', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      scaffolded(
        const TTSplitView(
          listPane: Text('Orders list'),
          detailPane: Text('Order detail'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Orders list'), findsOneWidget);
    expect(find.text('Order detail'), findsOneWidget);
  });

  testWidgets('TTSplitView shows one pane when narrow', (tester) async {
    await tester.pumpWidget(
      scaffolded(
        const TTSplitView(
          listPane: Text('Orders list'),
          detailPane: Text('Order detail'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Order detail'), findsOneWidget);
    expect(find.text('Orders list'), findsNothing);
  });

  testWidgets('TTHeroMap shows live ops, view action and 4 stats',
      (tester) async {
    var viewed = false;
    await tester.pumpWidget(
      harness(
        SingleChildScrollView(
          child: TTHeroMap(
            map: const Text('Live map'),
            onViewLiveOps: () => viewed = true,
            liveOps: const TTLiveOpsInfo(
              title: 'Live operations · 28 active',
              etaLabel: 'ETA',
              etaValue: '10:42',
              distanceLabel: 'Distance',
              distanceValue: '16.4 km',
              remainingLabel: 'Remaining',
              remainingValue: '3,520 IG',
              viewLabel: 'View',
            ),
            stats: const [
              TTStatData(label: 'Orders today', value: '87'),
              TTStatData(label: 'Active trips', value: '28'),
              TTStatData(label: 'Delayed', value: '4'),
              TTStatData(label: 'Breakdowns', value: '1'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Live map'), findsOneWidget);
    expect(find.text('Live operations · 28 active'), findsOneWidget);
    expect(find.text('10:42'), findsOneWidget);
    expect(find.text('87'), findsOneWidget);
    expect(find.text('Breakdowns'), findsOneWidget);
    await tester.tap(find.text('View'));
    await tester.pumpAndSettle();
    expect(viewed, isTrue);
  });

  testWidgets('TTStatStrip and TTStatusPill render', (tester) async {
    await tester.pumpWidget(
      harness(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TTStatStrip(
              stats: const [
                TTStatData(label: 'Loaded', value: '78,500 IG'),
                TTStatData(label: 'Delayed', value: '4'),
              ],
            ),
            TTStatusPill(style: StatusStyle.critical, label: 'Delayed'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('78,500 IG'), findsOneWidget);
    expect(find.text('Delayed'), findsNWidgets(2));
  });

  testWidgets('TTListRow tap fires and pill shows', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      harness(
        TTListRow(
          title: 'Ahmed Khan',
          subtitle: 'Tanker 07 · ETA 10:42',
          initials: 'AK',
          style: StatusStyle.active,
          pillLabel: 'In transit',
          onTap: () => tapped = true,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('AK'), findsOneWidget);
    expect(find.text('In transit'), findsOneWidget);
    await tester.tap(find.text('Ahmed Khan'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('TTEntityCard tap fires and details show', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      harness(
        SingleChildScrollView(
          child: TTEntityCard(
            title: 'ABC Trading',
            subtitle: 'Industrial City',
            details: const ['3,520 IG · 16.4 km'],
            statusStyle: StatusStyle.active,
            statusLabel: 'In transit',
            onTap: () => tapped = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('3,520 IG · 16.4 km'), findsOneWidget);
    await tester.tap(find.text('ABC Trading'));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('TTMatchColumn selects candidates', (tester) async {
    var selected = 0;
    await tester.pumpWidget(
      harness(
        SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => TTMatchColumn(
              title: 'Best matches',
              candidates: const [
                TTMatchCandidate(title: 'Tanker 07', subtitle: '4.2 km away'),
                TTMatchCandidate(title: 'Tanker 12', subtitle: '9.8 km away'),
              ],
              selectedIndex: selected,
              onSelect: (i) => setState(() => selected = i),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tanker 12'));
    await tester.pumpAndSettle();
    expect(selected, 1);
  });

  testWidgets('TTValidationSheet animates rows and gates confirm',
      (tester) async {
    var confirmed = false;
    await tester.pumpWidget(
      harness(
        SingleChildScrollView(
          child: TTValidationSheet(
            title: 'Validate trip',
            confirmLabel: 'Confirm dispatch',
            onConfirm: () => confirmed = true,
            checks: const [
              TTValidationCheck(label: 'Capacity ok', passed: true),
              TTValidationCheck(label: 'Shift active', passed: true),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Capacity ok'), findsOneWidget);
    expect(find.text('Shift active'), findsOneWidget);
    await tester.tap(find.text('Confirm dispatch'));
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);
  });

  testWidgets('TTValidationSheet disables confirm when a check fails',
      (tester) async {
    await tester.pumpWidget(
      harness(
        SingleChildScrollView(
          child: TTValidationSheet(
            title: 'Validate trip',
            confirmLabel: 'Confirm dispatch',
            onConfirm: () {},
            checks: const [
              TTValidationCheck(label: 'Capacity ok', passed: true),
              TTValidationCheck(label: 'Stock short', passed: false),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final confirm = tester.widget<ElevatedButton>(
      find.ancestor(
        of: find.text('Confirm dispatch'),
        matching: find.byType(ElevatedButton),
      ),
    );
    expect(confirm.onPressed, isNull);
  });

  testWidgets('TTStepProgress shows steps and current', (tester) async {
    await tester.pumpWidget(
      harness(
        const TTStepProgress(
          current: 1,
          steps: [
            TTStepData(label: 'Verify'),
            TTStepData(label: 'Vehicle'),
            TTStepData(label: 'Start shift'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Verify'), findsOneWidget);
    expect(find.text('Vehicle'), findsOneWidget);
    expect(find.text('Start shift'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });

  testWidgets('TTAllocationBar shows total and segments', (tester) async {
    await tester.pumpWidget(
      harness(
        const TTAllocationBar(
          totalLabel: 'TRIP-260021',
          totalValue: '5,000 IG',
          segments: [
            TTAllocationSegment(
              label: 'ABC · 1,500 IG',
              value: 1500,
              style: StatusStyle.completed,
            ),
            TTAllocationSegment(
              label: 'XYZ · 2,000 IG',
              value: 2000,
              style: StatusStyle.active,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('5,000 IG'), findsOneWidget);
    expect(find.text('ABC · 1,500 IG'), findsOneWidget);
    expect(find.text('XYZ · 2,000 IG'), findsOneWidget);
  });

  testWidgets('TTBottomActionBar fires primary and secondary',
      (tester) async {
    var primary = false;
    var secondary = false;
    await tester.pumpWidget(
      scaffolded(
        Column(
          children: [
            const Expanded(child: SizedBox.shrink()),
            TTBottomActionBar(
              title: 'TRIP-260021',
              primaryLabel: 'Confirm dispatch',
              onPrimary: () => primary = true,
              secondaryLabel: 'Save draft',
              onSecondary: () => secondary = true,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save draft'));
    await tester.pumpAndSettle();
    expect(secondary, isTrue);
    await tester.tap(find.text('Confirm dispatch'));
    await tester.pumpAndSettle();
    expect(primary, isTrue);
  });

  testWidgets('ScreenStateHost renders each state', (tester) async {
    for (final state in ScreenStateKind.values) {
      await tester.pumpWidget(
        scaffolded(
          ScreenStateHost(
            state: state,
            emptyTitle: 'No orders yet',
            emptyMessage: 'Orders appear here.',
            loadingLabel: 'Loading orders…',
            errorTitle: 'Load failed',
            errorMessage: 'Retry soon.',
            retryLabel: 'Retry',
            onRetry: () {},
            child: const Text('87 orders'),
          ),
        ),
      );
      // Single pump: the loading state's progress indicator never settles.
      await tester.pump();
      switch (state) {
        case ScreenStateKind.empty:
          expect(find.text('No orders yet'), findsOneWidget);
        case ScreenStateKind.loading:
          expect(find.text('Loading orders…'), findsOneWidget);
        case ScreenStateKind.error:
          expect(find.text('Load failed'), findsOneWidget);
        case ScreenStateKind.success:
          expect(find.text('87 orders'), findsOneWidget);
      }
    }
  });

  testWidgets('ScreenStateHost demo switcher reports selection',
      (tester) async {
    ScreenStateKind? picked;
    await tester.pumpWidget(
      scaffolded(
        ScreenStateHost(
          state: ScreenStateKind.empty,
          emptyTitle: 'No orders yet',
          emptyMessage: 'Orders appear here.',
          loadingLabel: 'Loading…',
          errorTitle: 'Failed',
          errorMessage: 'Retry.',
          retryLabel: 'Retry',
          onRetry: () {},
          demoTitle: 'Demo state',
          demoLabels: const {
            ScreenStateKind.empty: 'Empty',
            ScreenStateKind.loading: 'Loading',
            ScreenStateKind.error: 'Error',
            ScreenStateKind.success: 'Success',
          },
          onDemoSelect: (s) => picked = s,
          child: const Text('87 orders'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Demo state'), findsOneWidget);
    await tester.tap(find.text('Error'));
    await tester.pumpAndSettle();
    expect(picked, ScreenStateKind.error);
  });

  testWidgets('TTIdleTimeoutDialog stay and sign-out fire', (tester) async {
    var stayed = false;
    var signedOut = false;
    await tester.pumpWidget(
      harness(
        SingleChildScrollView(
          child: TTIdleTimeoutDialog(
            title: 'Still there?',
            countdownLabel: 'Signing out in 1:24.',
            stayLabel: 'Stay signed in',
            signOutLabel: 'Sign out now',
            onStay: () => stayed = true,
            onSignOut: () => signedOut = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Signing out in 1:24.'), findsOneWidget);
    await tester.tap(find.text('Stay signed in'));
    await tester.pumpAndSettle();
    expect(stayed, isTrue);
    await tester.tap(find.text('Sign out now'));
    await tester.pumpAndSettle();
    expect(signedOut, isTrue);
  });

  testWidgets('TTAboutDialog shows credits and closes', (tester) async {
    var closed = false;
    await tester.pumpWidget(
      harness(
        SingleChildScrollView(
          child: TTAboutDialog(
            title: 'About TankerTrack',
            message: 'Fuel distribution, calmly under control.',
            photoCredits: 'Photos: licensed depot imagery.',
            closeLabel: 'Close',
            onClose: () => closed = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Photos: licensed depot imagery.'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(closed, isTrue);
  });

  testWidgets('r3 components pump in RTL', (tester) async {
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
                topBar(),
                const SizedBox(
                  width: 400,
                  child: TTCommandPalette(
                    hint: 'Search…',
                    noResults: 'Nothing.',
                    shortcutHint: 'Enter',
                    onSelect: _noopCommand,
                    items: [
                      TTCommandItem(title: 'SO-260145'),
                    ],
                  ),
                ),
                const TTSplitView(
                  listPane: Text('List'),
                  detailPane: Text('Detail'),
                ),
                const TTHeroMap(
                  map: Text('Map'),
                  liveOps: TTLiveOpsInfo(
                    title: 'Live',
                    etaLabel: 'ETA',
                    etaValue: '10:42',
                    distanceLabel: 'Dist',
                    distanceValue: '1 km',
                    remainingLabel: 'Left',
                    remainingValue: '5 IG',
                    viewLabel: 'View',
                  ),
                  stats: [TTStatData(label: 'A', value: '1')],
                ),
                const TTListRow(title: 'T', subtitle: 'S'),
                const TTEntityCard(title: 'T'),
                const TTMatchColumn(
                  title: 'M',
                  candidates: [TTMatchCandidate(title: 'C', subtitle: 'S')],
                  selectedIndex: 0,
                  onSelect: _noopInt,
                ),
                const TTValidationSheet(
                  title: 'V',
                  confirmLabel: 'OK',
                  checks: [TTValidationCheck(label: 'C', passed: true)],
                ),
                const TTStepProgress(
                  current: 0,
                  steps: [TTStepData(label: 'One')],
                ),
                const TTAllocationBar(
                  segments: [
                    TTAllocationSegment(
                      label: 'A',
                      value: 1,
                      style: StatusStyle.active,
                    ),
                  ],
                ),
                TTBottomActionBar(
                  primaryLabel: 'Go',
                  onPrimary: () {},
                ),
                const SizedBox(
                  height: 200,
                  child: ScreenStateHost(
                    state: ScreenStateKind.empty,
                    emptyTitle: 'E',
                    emptyMessage: 'M',
                    loadingLabel: 'L',
                    errorTitle: 'Er',
                    errorMessage: 'Em',
                    retryLabel: 'R',
                    child: Text('C'),
                  ),
                ),
                const TTIdleTimeoutDialog(
                  title: 'T',
                  countdownLabel: 'C',
                  stayLabel: 'S',
                  signOutLabel: 'O',
                  onStay: null,
                  onSignOut: null,
                ),
                const TTAboutDialog(
                  title: 'T',
                  message: 'M',
                  photoCredits: 'P',
                  closeLabel: 'C',
                  onClose: null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TTTopBar), findsOneWidget);
    expect(find.byType(TTCommandPalette), findsOneWidget);
    expect(find.byType(TTSplitView), findsOneWidget);
    expect(find.byType(TTHeroMap), findsOneWidget);
    expect(find.byType(TTListRow), findsOneWidget);
    expect(find.byType(TTEntityCard), findsOneWidget);
    expect(find.byType(TTMatchColumn), findsOneWidget);
    expect(find.byType(TTValidationSheet), findsOneWidget);
    expect(find.byType(TTStepProgress), findsOneWidget);
    expect(find.byType(TTAllocationBar), findsOneWidget);
    expect(find.byType(TTBottomActionBar), findsOneWidget);
    expect(find.byType(ScreenStateHost), findsOneWidget);
    expect(find.byType(TTIdleTimeoutDialog), findsOneWidget);
    expect(find.byType(TTAboutDialog), findsOneWidget);
  });
}

void _noopInt(int _) {}

void _noopCommand(TTCommandItem _) {}
