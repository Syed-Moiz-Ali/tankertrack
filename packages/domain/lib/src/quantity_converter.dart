import 'package:json_annotation/json_annotation.dart';

import 'quantity_ig.dart';

/// JSON converter between integer tenths and [QuantityIG].
///
/// Seeds and ledger payloads carry quantities as integer tenths of an
/// Imperial Gallon (exact math); this converter bridges that wire format
/// to the [QuantityIG] value object.
class QuantityTenthsConverter extends JsonConverter<QuantityIG, int> {
  const QuantityTenthsConverter();

  @override
  QuantityIG fromJson(int json) => QuantityIG(json);

  @override
  int toJson(QuantityIG object) => object.tenthGallons;
}
