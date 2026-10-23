/// Centralized asset URIs for the design system.
///
/// Consumers must reference these constants — never hard-code asset paths
/// in widgets. URIs use the full `packages/design_system/...` form so
/// `SvgPicture.asset` resolves them from any consuming package.
abstract final class AppAssets {
  /// TankerTrack mark (fuel-drop + route-pin fusion).
  static const String logoMark =
      'packages/design_system/assets/brand/logo_mark.svg';

  /// Side-view tanker truck illustration.
  static const String tanker =
      'packages/design_system/assets/illustrations/tanker.svg';

  /// Fuel depot tanks illustration.
  static const String depot =
      'packages/design_system/assets/illustrations/depot.svg';

  /// Driver avatar bust illustration.
  static const String driver =
      'packages/design_system/assets/illustrations/driver.svg';

  /// Empty tasks state (clipboard + droplet) illustration.
  static const String emptyTasks =
      'packages/design_system/assets/illustrations/empty_tasks.svg';

  /// Empty map state (map pin + roads) illustration.
  static const String emptyMap =
      'packages/design_system/assets/illustrations/empty_map.svg';

  /// Breakdown state (truck + warning triangle) illustration.
  static const String breakdown =
      'packages/design_system/assets/illustrations/breakdown.svg';
}
