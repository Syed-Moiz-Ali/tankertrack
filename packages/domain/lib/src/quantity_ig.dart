/// Imperial-Gallon quantity as **integer tenths of a gallon**.
///
/// All ledger arithmetic is exact integer math — zero floating-point drift.
/// Display formatting (1 decimal IG, litre conversion) lives in `package:l10n`
/// and is display-only; it never feeds back into the ledger.
class QuantityIG implements Comparable<QuantityIG> {
  const QuantityIG(this.tenthGallons);

  /// Tenths of an Imperial Gallon. 4,000 IG == 40000.
  final int tenthGallons;

  static const zero = QuantityIG(0);

  factory QuantityIG.fromIg(double ig) => QuantityIG((ig * 10).round());

  double get asIg => tenthGallons / 10;

  double toLitres(double litrePerIg) => asIg * litrePerIg;

  bool get isZero => tenthGallons == 0;
  bool get isNegative => tenthGallons < 0;
  bool get isPositive => tenthGallons > 0;

  QuantityIG operator +(QuantityIG other) =>
      QuantityIG(tenthGallons + other.tenthGallons);

  QuantityIG operator -(QuantityIG other) =>
      QuantityIG(tenthGallons - other.tenthGallons);

  QuantityIG abs() => QuantityIG(tenthGallons.abs());

  @override
  int compareTo(QuantityIG other) =>
      tenthGallons.compareTo(other.tenthGallons);

  bool operator >(QuantityIG other) => compareTo(other) > 0;
  bool operator >=(QuantityIG other) => compareTo(other) >= 0;
  bool operator <(QuantityIG other) => compareTo(other) < 0;
  bool operator <=(QuantityIG other) => compareTo(other) <= 0;

  @override
  bool operator ==(Object other) =>
      other is QuantityIG && other.tenthGallons == tenthGallons;

  @override
  int get hashCode => tenthGallons.hashCode;

  @override
  String toString() => 'QuantityIG($tenthGallons/10)';
}
