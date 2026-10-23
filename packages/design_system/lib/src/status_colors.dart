import 'package:flutter/material.dart';

/// Canonical status colors (hue fixed per Image-1 color legend, luminance
/// adjusted per brightness for AA contrast).
///
/// Reserved for statuses ONLY — never for branding or decoration.
/// Accessed via `context.status` (see `context_ext.dart`).
@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.completed,
    required this.onCompleted,
    required this.completedBg,
    required this.active,
    required this.onActive,
    required this.activeBg,
    required this.loading,
    required this.onLoading,
    required this.loadingBg,
    required this.unloading,
    required this.onUnloading,
    required this.unloadingBg,
    required this.waiting,
    required this.onWaiting,
    required this.waitingBg,
    required this.critical,
    required this.onCritical,
    required this.criticalBg,
    required this.offline,
    required this.onOffline,
    required this.offlineBg,
  });

  final Color completed;
  final Color onCompleted;
  final Color completedBg;
  final Color active;
  final Color onActive;
  final Color activeBg;
  final Color loading;
  final Color onLoading;
  final Color loadingBg;
  final Color unloading;
  final Color onUnloading;
  final Color unloadingBg;
  final Color waiting;
  final Color onWaiting;
  final Color waitingBg;
  final Color critical;
  final Color onCritical;
  final Color criticalBg;
  final Color offline;
  final Color onOffline;
  final Color offlineBg;

  static const StatusColors light = StatusColors(
    completed: Color(0xFF16A34A),
    onCompleted: Color(0xFFFFFFFF),
    completedBg: Color(0x1F16A34A),
    active: Color(0xFF2563EB),
    onActive: Color(0xFFFFFFFF),
    activeBg: Color(0x1F2563EB),
    loading: Color(0xFF7C3AED),
    onLoading: Color(0xFFFFFFFF),
    loadingBg: Color(0x1F7C3AED),
    unloading: Color(0xFF0D9488),
    onUnloading: Color(0xFFFFFFFF),
    unloadingBg: Color(0x1F0D9488),
    waiting: Color(0xFFB45309),
    onWaiting: Color(0xFFFFFFFF),
    waitingBg: Color(0x1FF59E0B),
    critical: Color(0xFFDC2626),
    onCritical: Color(0xFFFFFFFF),
    criticalBg: Color(0x1FDC2626),
    offline: Color(0xFF6B7280),
    onOffline: Color(0xFFFFFFFF),
    offlineBg: Color(0x1F6B7280),
  );

  static const StatusColors dark = StatusColors(
    completed: Color(0xFF4ADE80),
    onCompleted: Color(0xFF052E16),
    completedBg: Color(0x334ADE80),
    active: Color(0xFF60A5FA),
    onActive: Color(0xFF172554),
    activeBg: Color(0x3360A5FA),
    loading: Color(0xFFA78BFA),
    onLoading: Color(0xFF2E1065),
    loadingBg: Color(0x33A78BFA),
    unloading: Color(0xFF2DD4BF),
    onUnloading: Color(0xFF042F2E),
    unloadingBg: Color(0x332DD4BF),
    waiting: Color(0xFFFBBF24),
    onWaiting: Color(0xFF451A03),
    waitingBg: Color(0x33FBBF24),
    critical: Color(0xFFF87171),
    onCritical: Color(0xFF450A0A),
    criticalBg: Color(0x33F87171),
    offline: Color(0xFF9CA3AF),
    onOffline: Color(0xFF111827),
    offlineBg: Color(0x339CA3AF),
  );

  @override
  StatusColors copyWith({
    Color? completed,
    Color? onCompleted,
    Color? completedBg,
    Color? active,
    Color? onActive,
    Color? activeBg,
    Color? loading,
    Color? onLoading,
    Color? loadingBg,
    Color? unloading,
    Color? onUnloading,
    Color? unloadingBg,
    Color? waiting,
    Color? onWaiting,
    Color? waitingBg,
    Color? critical,
    Color? onCritical,
    Color? criticalBg,
    Color? offline,
    Color? onOffline,
    Color? offlineBg,
  }) {
    return StatusColors(
      completed: completed ?? this.completed,
      onCompleted: onCompleted ?? this.onCompleted,
      completedBg: completedBg ?? this.completedBg,
      active: active ?? this.active,
      onActive: onActive ?? this.onActive,
      activeBg: activeBg ?? this.activeBg,
      loading: loading ?? this.loading,
      onLoading: onLoading ?? this.onLoading,
      loadingBg: loadingBg ?? this.loadingBg,
      unloading: unloading ?? this.unloading,
      onUnloading: onUnloading ?? this.onUnloading,
      unloadingBg: unloadingBg ?? this.unloadingBg,
      waiting: waiting ?? this.waiting,
      onWaiting: onWaiting ?? this.onWaiting,
      waitingBg: waitingBg ?? this.waitingBg,
      critical: critical ?? this.critical,
      onCritical: onCritical ?? this.onCritical,
      criticalBg: criticalBg ?? this.criticalBg,
      offline: offline ?? this.offline,
      onOffline: onOffline ?? this.onOffline,
      offlineBg: offlineBg ?? this.offlineBg,
    );
  }

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) {
    if (other is! StatusColors) return this;
    Color lerpColor(Color a, Color b) => Color.lerp(a, b, t)!;
    return StatusColors(
      completed: lerpColor(completed, other.completed),
      onCompleted: lerpColor(onCompleted, other.onCompleted),
      completedBg: lerpColor(completedBg, other.completedBg),
      active: lerpColor(active, other.active),
      onActive: lerpColor(onActive, other.onActive),
      activeBg: lerpColor(activeBg, other.activeBg),
      loading: lerpColor(loading, other.loading),
      onLoading: lerpColor(onLoading, other.onLoading),
      loadingBg: lerpColor(loadingBg, other.loadingBg),
      unloading: lerpColor(unloading, other.unloading),
      onUnloading: lerpColor(onUnloading, other.onUnloading),
      unloadingBg: lerpColor(unloadingBg, other.unloadingBg),
      waiting: lerpColor(waiting, other.waiting),
      onWaiting: lerpColor(onWaiting, other.onWaiting),
      waitingBg: lerpColor(waitingBg, other.waitingBg),
      critical: lerpColor(critical, other.critical),
      onCritical: lerpColor(onCritical, other.onCritical),
      criticalBg: lerpColor(criticalBg, other.criticalBg),
      offline: lerpColor(offline, other.offline),
      onOffline: lerpColor(onOffline, other.onOffline),
      offlineBg: lerpColor(offlineBg, other.offlineBg),
    );
  }
}

/// Display style key for [StatusChip]. Domain statuses map to these in
/// `fleet_ui` (design_system stays dependency-free).
enum StatusStyle {
  completed,
  active,
  loading,
  unloading,
  waiting,
  critical,
  offline,
}
