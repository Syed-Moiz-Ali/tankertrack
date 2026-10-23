import 'package:flutter/material.dart';

import '../context_ext.dart';
import 'tt_gap.dart';

/// Month calendar with per-day commitment dots (FRS §13 availability).
/// Pure + direction-aware (week starts Saturday for ar, Sunday… no —
/// week start follows MaterialLocalizations.firstDayOfWeekIndex, so both
/// locales behave natively). All labels passed in (zero strings inside).
class TTMonthCalendar extends StatelessWidget {
  const TTMonthCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.commitments,
    required this.weekdayLabels,
    this.selected,
    this.onSelectDay,
  });

  final int year;
  final int month;

  /// Day-of-month → commitment count (dot intensity).
  final Map<int, int> commitments;
  final List<String> weekdayLabels;
  final DateTime? selected;
  final void Function(DateTime)? onSelectDay;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.tokens;
    final first = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Monday-first offset rotated by locale's first day of week.
    final localeFirst =
        MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final lead = (first.weekday - localeFirst) % 7;
    final cells = <Widget>[];
    for (var i = 0; i < 7; i++) {
      cells.add(
        Center(
          child: Text(
            weekdayLabels[i],
            style: context.text.labelSmall,
          ),
        ),
      );
    }
    for (var i = 0; i < lead; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      final date = DateTime(year, month, day);
      final isSelected = selected != null &&
          selected!.year == year &&
          selected!.month == month &&
          selected!.day == day;
      final count = commitments[day] ?? 0;
      cells.add(
        GestureDetector(
          onTap: onSelectDay == null ? null : () => onSelectDay!(date),
          child: Semantics(
            button: onSelectDay != null,
            label: '$year-$month-$day',
            child: Container(
              margin: EdgeInsets.all(t.spaceXs / 2),
              decoration: BoxDecoration(
                color: isSelected ? c.primary : null,
                borderRadius: BorderRadius.circular(t.radiusCard),
                border: Border.all(
                  color: isSelected ? c.primary : c.outlineVariant,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$day',
                    style: (isSelected
                            ? context.text.titleSmall
                                ?.copyWith(color: c.onPrimary)
                            : context.text.titleSmall),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var d = 0; d < count.clamp(0, 3); d++)
                        Container(
                          width: t.spaceXs,
                          height: t.spaceXs,
                          margin: EdgeInsets.symmetric(
                            horizontal: t.spaceXs / 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? c.onPrimary : c.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.count(
          crossAxisCount: 7,
          // Wide cells keep 6-row months inside phone viewports.
          childAspectRatio: 1.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: cells,
        ),
        const TTGap.sm(),
      ],
    );
  }
}
