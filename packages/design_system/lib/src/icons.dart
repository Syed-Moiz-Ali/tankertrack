import 'package:flutter/material.dart';

/// Semantic icon descriptor. Feature code uses [AppIcons] names ONLY —
/// never `Icons.*` / `CupertinoIcons.*` (lint-enforced).
///
/// [directional] icons are mirrored in RTL via [iconFor]; all others render
/// identically in both directions.
class AppIcon {
  const AppIcon(this.data, {this.directional = false});
  final IconData data;
  final bool directional;
}

class AppIcons {
  const AppIcons._();

  static IconData iconFor(AppIcon icon, BuildContext context) {
    if (!icon.directional) return icon.data;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    if (!rtl) return icon.data;
    // Mirror by code-point pair where Material provides LTR/RTL twins.
    return _rtlTwins[icon.data] ?? icon.data;
  }

  static final Map<IconData, IconData> _rtlTwins = {
    Icons.arrow_forward: Icons.arrow_back,
    Icons.arrow_back: Icons.arrow_forward,
    Icons.chevron_right: Icons.chevron_left,
    Icons.chevron_left: Icons.chevron_right,
    Icons.navigate_next: Icons.navigate_before,
    Icons.navigate_before: Icons.navigate_next,
  };

  // Navigation / directional.
  static const AppIcon back = AppIcon(Icons.arrow_back, directional: true);
  static const AppIcon forward = AppIcon(Icons.arrow_forward, directional: true);
  static const AppIcon next = AppIcon(Icons.chevron_right, directional: true);

  // Domain.
  static const AppIcon fuelDrop = AppIcon(Icons.water_drop_outlined);
  static const AppIcon truck = AppIcon(Icons.local_shipping_outlined);
  static const AppIcon depot = AppIcon(Icons.warehouse_outlined);
  static const AppIcon customer = AppIcon(Icons.storefront_outlined);
  static const AppIcon route = AppIcon(Icons.route_outlined);
  static const AppIcon navigation = AppIcon(Icons.navigation_outlined);
  static const AppIcon breakdown = AppIcon(Icons.warning_amber_rounded);
  static const AppIcon incident = AppIcon(Icons.report_problem_outlined);
  static const AppIcon inspection = AppIcon(Icons.fact_check_outlined);
  static const AppIcon signature = AppIcon(Icons.draw_outlined);
  static const AppIcon photo = AppIcon(Icons.photo_camera_outlined);
  static const AppIcon pod = AppIcon(Icons.receipt_long_outlined);

  // Status / sync.
  static const AppIcon synced = AppIcon(Icons.check_circle_outline);
  static const AppIcon pending = AppIcon(Icons.schedule_outlined);
  static const AppIcon failed = AppIcon(Icons.error_outline);
  static const AppIcon tracking = AppIcon(Icons.gps_fixed);
  static const AppIcon offline = AppIcon(Icons.cloud_off_outlined);

  // Generic UI.
  static const AppIcon search = AppIcon(Icons.search);
  static const AppIcon filter = AppIcon(Icons.filter_list);
  static const AppIcon close = AppIcon(Icons.close);
  static const AppIcon add = AppIcon(Icons.add);
  static const AppIcon remove = AppIcon(Icons.remove);
  static const AppIcon refresh = AppIcon(Icons.refresh);
  static const AppIcon language = AppIcon(Icons.language);
  static const AppIcon theme = AppIcon(Icons.contrast_outlined);
  static const AppIcon user = AppIcon(Icons.person_outline);
  static const AppIcon logout = AppIcon(Icons.logout);
  static const AppIcon visibility = AppIcon(Icons.visibility_outlined);
  static const AppIcon visibilityOff = AppIcon(Icons.visibility_off_outlined);
  static const AppIcon check = AppIcon(Icons.check);
  static const AppIcon chevronDown = AppIcon(Icons.expand_more);
  static const AppIcon info = AppIcon(Icons.info_outline);
  static const AppIcon bell = AppIcon(Icons.notifications_outlined);
  static const AppIcon message = AppIcon(Icons.mail_outline);
  static const AppIcon settings = AppIcon(Icons.settings_outlined);
  static const AppIcon calendar = AppIcon(Icons.calendar_today_outlined);
  static const AppIcon clock = AppIcon(Icons.access_time);
  static const AppIcon dashboard = AppIcon(Icons.dashboard_outlined);
  static const AppIcon report = AppIcon(Icons.bar_chart_outlined);
  static const AppIcon map = AppIcon(Icons.map_outlined);
}
