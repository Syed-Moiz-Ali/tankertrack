/// Bilingual reason code. Every override / reassign / cancel / adjustment
/// requires one (FRS §23) and is written to the audit log.
class ReasonCode {
  const ReasonCode({
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.appliesTo,
  });

  final String code;
  final String nameEn;
  final String nameAr;
  final Set<ReasonAppliesTo> appliesTo;

  String label({required bool arabic}) => arabic ? nameAr : nameEn;
}

enum ReasonAppliesTo {
  override,
  reassign,
  cancel,
  quantityAdjustment,
  variance,
  tripAmendment,
  statusChange,
}

/// Seed catalogue (admin-extensible in Configuration, P8).
class ReasonCodes {
  const ReasonCodes._();

  static const List<ReasonCode> defaults = [
    ReasonCode(
      code: 'CAPACITY_OVERRIDE',
      nameEn: 'Capacity exceeded — supervisor approved',
      nameAr: 'تجاوز السعة — بموافقة المشرف',
      appliesTo: {ReasonAppliesTo.override},
    ),
    ReasonCode(
      code: 'BALANCE_OVERRIDE',
      nameEn: 'Over on-board balance — supervisor approved',
      nameAr: 'تجاوز رصيد المركبة — بموافقة المشرف',
      appliesTo: {ReasonAppliesTo.override},
    ),
    ReasonCode(
      code: 'REASSIGN_BREAKDOWN',
      nameEn: 'Reassigned after breakdown',
      nameAr: 'إعادة إسناد بعد عطل',
      appliesTo: {ReasonAppliesTo.reassign},
    ),
    ReasonCode(
      code: 'REASSIGN_DELAY',
      nameEn: 'Reassigned to recover delay',
      nameAr: 'إعادة إسناد لتعويض التأخير',
      appliesTo: {ReasonAppliesTo.reassign},
    ),
    ReasonCode(
      code: 'METER_VARIANCE',
      nameEn: 'Meter vs planned variance',
      nameAr: 'فرق العداد عن المخطط',
      appliesTo: {ReasonAppliesTo.variance, ReasonAppliesTo.quantityAdjustment},
    ),
    ReasonCode(
      code: 'SPILL_SHORTAGE',
      nameEn: 'Shortage (spill / handling loss)',
      nameAr: 'نقص (انسكاب / فقدان مناولة)',
      appliesTo: {ReasonAppliesTo.variance, ReasonAppliesTo.quantityAdjustment},
    ),
    ReasonCode(
      code: 'CUSTOMER_REQUEST',
      nameEn: 'Customer request',
      nameAr: 'طلب العميل',
      appliesTo: {ReasonAppliesTo.cancel, ReasonAppliesTo.tripAmendment},
    ),
    ReasonCode(
      code: 'DATA_CORRECTION',
      nameEn: 'Data entry correction (post-closure)',
      nameAr: 'تصحيح إدخال (بعد الإغلاق)',
      appliesTo: {ReasonAppliesTo.tripAmendment, ReasonAppliesTo.statusChange},
    ),
  ];

  static List<ReasonCode> forUse(ReasonAppliesTo use, {bool includeAll = false}) {
    if (includeAll) return List.unmodifiable(defaults);
    return defaults.where((r) => r.appliesTo.contains(use)).toList();
  }
}
