import 'package:fleet_ui/fleet_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(List<MapPosition> positions, {String? title}) => MaterialApp(
      theme: AppTheme.build(
        surface: AppSurface.web,
        brightness: Brightness.light,
        arabic: false,
      ),
      home: Scaffold(
        body: MiniMap(positions: positions, title: title),
      ),
    );

List<MapPosition> _fleet() => const [
      MapPosition(
        id: 'T-214',
        lat: 24.63,
        lng: 46.72,
        style: StatusStyle.active,
        label: 'T-214',
      ),
      MapPosition(
        id: 'T-215',
        lat: 24.71,
        lng: 46.85,
        style: StatusStyle.critical,
      ),
      MapPosition(
        id: 'T-216',
        lat: 24.55,
        lng: 46.60,
        style: StatusStyle.loading,
      ),
    ];

void main() {
  test('MapPosition carries contract fields', () {
    const p = MapPosition(
      id: 'T-1',
      lat: 24.6,
      lng: 46.7,
      style: StatusStyle.waiting,
    );
    expect(p.id, 'T-1');
    expect(p.lat, 24.6);
    expect(p.lng, 46.7);
    expect(p.style, StatusStyle.waiting);
    expect(p.label, isNull);
  });

  testWidgets('renders dots + title, height from tokens only', (tester) async {
    await tester.pumpWidget(_host(_fleet(), title: 'Live fleet'));
    await tester.pumpAndSettle();
    expect(find.text('Live fleet'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    final ctx = tester.element(find.byType(MiniMap));
    final expected = ctx.tokens.spaceXxxl * 5;
    expect(
      find.byWidgetPredicate(
        (w) => w is SizedBox && w.height == expected,
      ),
      findsOneWidget,
    );
  });

  testWidgets('empty fleet renders surface without crashing', (tester) async {
    await tester.pumpWidget(_host(const []));
    await tester.pumpAndSettle();
    expect(find.byType(MiniMap), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('single position (degenerate bounds) renders', (tester) async {
    await tester.pumpWidget(
      _host(const [
        MapPosition(
          id: 'T-1',
          lat: 24.63,
          lng: 46.72,
          style: StatusStyle.active,
        ),
      ]),
    );
    await tester.pumpAndSettle();
    expect(find.byType(MiniMap), findsOneWidget);
  });
}
