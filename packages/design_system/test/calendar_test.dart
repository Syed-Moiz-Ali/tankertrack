import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TTMonthCalendar renders days + dots, selects day',
      (tester) async {
    DateTime? picked;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.build(
          surface: AppSurface.web,
          brightness: Brightness.light,
          arabic: false,
        ),
        home: Scaffold(
          body: TTMonthCalendar(
            year: 2026,
            month: 10,
            commitments: const {5: 2, 23: 3},
            weekdayLabels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
            onSelectDay: (d) => picked = d,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('23'), findsOneWidget);
    await tester.tap(find.text('23'));
    await tester.pumpAndSettle();
    expect(picked, DateTime(2026, 10, 23));
  });
}
