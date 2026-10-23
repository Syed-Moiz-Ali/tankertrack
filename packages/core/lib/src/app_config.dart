/// Compile-time feature flags for FRS §32 open decisions + G-gaps.
/// UI-first defaults follow `docs/plan/00-open-questions.md`.
class FeatureFlags {
  const FeatureFlags({
    this.compartments = false,
    this.requireOtp = false,
    this.podRequireName = true,
    this.podRequireSignature = true,
    this.podRequirePhoto = false,
    this.requireDriverAccept = true,
    this.requireInspectionBeforeStartDay = true,
    this.orderScheduledAlias = true,
    this.orderDeliveredAlias = true,
  });

  /// Per-compartment ledger (D3). OFF for MVP — single-tanker balance.
  final bool compartments;

  /// OTP step in POD (D7). OFF for MVP.
  final bool requireOtp;

  /// POD compulsory fields (D7/G1). Default: name + (signature OR photo).
  /// Signature and photo are alternatives unless BOTH are true.
  final bool podRequireName;
  final bool podRequireSignature;
  final bool podRequirePhoto;

  /// Driver must tap Accept before a task starts (C7). Default ON.
  final bool requireDriverAccept;

  /// Pre-trip inspection must pass before Start Day (C4). Default ON.
  final bool requireInspectionBeforeStartDay;

  /// Show `Scheduled` as an alias of Assigned with a planned date (C1).
  final bool orderScheduledAlias;

  /// Show `Delivered` as an alias of Completed for single-drop orders (C1).
  final bool orderDeliveredAlias;

  /// POD rule summary: name + (signature OR photo) by default.
  bool podSatisfied({
    required bool hasName,
    required bool hasSignature,
    required bool hasPhoto,
  }) {
    if (podRequireName && !hasName) return false;
    if (podRequireSignature && podRequirePhoto) {
      return hasSignature && hasPhoto;
    }
    if (podRequireSignature || podRequirePhoto) {
      return hasSignature || hasPhoto;
    }
    return true;
  }
}

/// Runtime-tunable operational config (Configuration screen, admin only).
/// Durations/intervals live here — never magic numbers in widgets (08 §3.1).
class AppConfig {
  const AppConfig({
    this.flags = const FeatureFlags(),
    this.litrePerIg = 4.54609,
    this.toleranceLoadPct = 2,
    this.toleranceLoadAbsTenths = 200,
    this.toleranceDeliverPct = 1,
    this.toleranceDeliverAbsTenths = 100,
    this.gpsMovingSecs = 15,
    this.gpsStationarySecs = 60,
    this.gpsStaleSecs = 300,
    this.geofenceDepotM = 300,
    this.geofenceSiteM = 200,
    this.displayTimeZoneOffsetHours = 3,
    this.displayTimeZoneName = 'Asia/Riyadh',
    this.jwtMinutes = 15,
    this.refreshDriverHours = 12,
    this.refreshOfficeHours = 8,
    this.numeralsArabicIndic = false,
    this.hijriDisplay = false,
  });

  final FeatureFlags flags;

  /// Litres per Imperial Gallon (display conversion only).
  final double litrePerIg;

  /// Loading tolerance: ±2% or ±20 IG (greater applies).
  final int toleranceLoadPct;
  final int toleranceLoadAbsTenths;

  /// Delivery tolerance: ±1% or ±10 IG (greater applies).
  final int toleranceDeliverPct;
  final int toleranceDeliverAbsTenths;

  /// GPS cadence + stale threshold (G3).
  final int gpsMovingSecs;
  final int gpsStationarySecs;
  final int gpsStaleSecs;

  /// Geofence radii (G4).
  final int geofenceDepotM;
  final int geofenceSiteM;

  /// Display timezone (UTC stored). Default Asia/Riyadh until confirmed.
  final int displayTimeZoneOffsetHours;
  final String displayTimeZoneName;

  /// Auth lifetimes (G5).
  final int jwtMinutes;
  final int refreshDriverHours;
  final int refreshOfficeHours;

  /// Numerals + Hijri display (client-confirmed: Western/Gregorian primary).
  final bool numeralsArabicIndic;
  final bool hijriDisplay;

  static const defaults = AppConfig();
}
