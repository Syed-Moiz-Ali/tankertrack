import 'package:hijri/hijri_calendar.dart';

/// Numeral system for display. Storage is always Western digits.
enum Numerals { western, arabicIndic }

const _arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

/// Number formatting with configurable numerals (Western vs Arabic-Indic).
class NumberFmt {
  const NumberFmt({this.numerals = Numerals.western});

  final Numerals numerals;

  /// Applies the numeral system to an already-formatted numeric string.
  String apply(String western) {
    if (numerals == Numerals.western) return western;
    final buf = StringBuffer();
    for (final c in western.characters) {
      final d = int.tryParse(c);
      buf.write(d == null ? c : _arabicIndic[d]);
    }
    return buf.toString();
  }

  String integer(int value) => apply(_group(value.toString()));

  String _group(String digits) {
    final buf = StringBuffer();
    var count = 0;
    for (var i = digits.length - 1; i >= 0; i--) {
      buf.write(digits[i]);
      count++;
      if (count % 3 == 0 && i != 0) buf.write(',');
    }
    return buf.toString().split('').reversed.join();
  }
}

/// Extension for String.characters without importing characters package.
extension on String {
  Iterable<String> get characters => split('');
}

/// Quantity formatting. Domain stores IG as integer tenths of a gallon;
/// litres are display-only conversion (rate from config, default 4.54609).
class QuantityFmt {
  const QuantityFmt({required this.numbers, this.litreRate = 4.54609});

  final NumberFmt numbers;
  final double litreRate;

  /// '4,000.0 IG' (1 decimal, grouped).
  String ig(int tenthGallons, String unit) {
    final neg = tenthGallons < 0;
    final abs = tenthGallons.abs();
    final out = '${numbers.integer(abs ~/ 10)}.${abs % 10} $unit';
    return neg ? '-$out' : out;
  }

  /// Display-only litre conversion, rounded to whole litres.
  String litres(int tenthGallons, String unit) {
    final litres = (tenthGallons / 10 * litreRate).round();
    return '${numbers.integer(litres)} $unit';
  }
}

/// Date/time formatting. UTC stored; display in the configured zone.
/// Default zone `Asia/Riyadh` (fixed +03:00, no DST) until the client
/// confirms — full tz DB (`timezone` pkg) lands in P1 if needed.
class DateFmt {
  const DateFmt({
    this.numbers = const NumberFmt(),
    this.offsetHours = 3,
    this.hijri = false,
  });

  final NumberFmt numbers;
  final int offsetHours;
  final bool hijri;

  DateTime _local(DateTime utc) =>
      utc.toUtc().add(Duration(hours: offsetHours));

  String _two(int v) => v.toString().padLeft(2, '0');

  /// '2026-10-23 14:05' (+ optional Hijri line '١٤ ربيع الآخر ١٤٤٨').
  String dateTime(DateTime utc) {
    final l = _local(utc);
    final base = '${l.year}-${_two(l.month)}-${_two(l.day)} '
        '${_two(l.hour)}:${_two(l.minute)}';
    if (!hijri) return numbers.apply(base);
    final h = HijriCalendar.fromDate(l);
    return '${numbers.apply(base)}\n${numbers.apply('${h.hDay} ${h.longMonthName} ${h.hYear}')}';
  }

  String date(DateTime utc) {
    final l = _local(utc);
    return numbers.apply('${l.year}-${_two(l.month)}-${_two(l.day)}');
  }

  String time(DateTime utc) {
    final l = _local(utc);
    return numbers.apply('${_two(l.hour)}:${_two(l.minute)}');
  }
}
