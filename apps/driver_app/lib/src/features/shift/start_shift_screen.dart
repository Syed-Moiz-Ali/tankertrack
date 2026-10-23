import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';
import '../common/driver_screen_state.dart';

/// Assigned vehicle + last odometer. Demo constants mirror Figma scenario A
/// (Tanker 07, Ahmed Khan DRV-0028); the domain-data slice replaces this
/// provider with real seeds — the screen only reads the record, so the swap
/// is one line.
@immutable
class AssignedVehicle {
  const AssignedVehicle({
    required this.name,
    required this.plate,
    required this.shiftWindow,
    required this.capacityIg,
    required this.onboardIg,
    required this.lastOdometerKm,
  });

  final String name;
  final String plate;
  final String shiftWindow;
  final double capacityIg;
  final double onboardIg;
  final double lastOdometerKm;
}

final assignedVehicleProvider = Provider<AssignedVehicle>(
  (_) => const AssignedVehicle(
    name: 'Tanker 07',
    plate: 'Dubai A 12345',
    shiftWindow: '06:00\u201318:00',
    capacityIg: 5000,
    onboardIg: 0,
    lastOdometerKm: 128420,
  ),
);

/// DR-03 Start shift (R3 benchmark screen).
///
/// One decision per screen: confirm vehicle + odometer → pinned amber CTA
/// starts the shift. CTA stays disabled until the odometer does not decrease
/// (`dr_odometer_error`) AND location consent is given. Copy from ARB only;
/// Figma lines without keys are listed in the slice return, never hard-coded.
class StartShiftScreen extends ConsumerStatefulWidget {
  const StartShiftScreen({
    super.key,
    this.status = DriverScreenStatus.success,
  });

  /// Companion-state override (tests / demo switcher).
  final DriverScreenStatus status;

  @override
  ConsumerState<StartShiftScreen> createState() => _StartShiftScreenState();

  /// Parses driver-typed odometer input (tolerates grouping spaces/commas).
  /// Null = empty or unparseable (caller shows `requiredField`).
  @visibleForTesting
  static double? parseOdometer(String input) {
    final cleaned = input.replaceAll(RegExp('[\\s,]'), '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  /// Figma rule verbatim: "Must not decrease".
  @visibleForTesting
  static bool odometerDecreased(double value, double last) => value < last;

  /// CTA enable rule: valid non-decreasing odometer + location consent.
  @visibleForTesting
  static bool canStart({
    required double? odometer,
    required double last,
    required bool consent,
  }) =>
      consent && odometer != null && !odometerDecreased(odometer, last);
}

class _StartShiftScreenState extends ConsumerState<StartShiftScreen> {
  final _odometer = TextEditingController();
  bool _consent = false;

  @override
  void initState() {
    super.initState();
    _odometer.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _odometer.removeListener(_refresh);
    _odometer.dispose();
    super.dispose();
  }

  void _start() {
    ref.read(shiftStartedProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final online = ref.watch(connectionProvider);
    final session = ref.watch(sessionProvider);
    final vehicle = ref.watch(assignedVehicleProvider);
    final name = session?.displayName ?? '';
    final reading = StartShiftScreen.parseOdometer(_odometer.text);
    final decreased = reading != null &&
        StartShiftScreen.odometerDecreased(reading, vehicle.lastOdometerKm);
    final ready = StartShiftScreen.canStart(
      odometer: reading,
      last: vehicle.lastOdometerKm,
      consent: _consent,
    );

    return TTScaffold(
      appBar: TTAppBar(title: l10n.dr_good_morning(name)),
      banner: online
          ? null
          : TTBanner(message: l10n.offline, kind: TTBannerKind.offline),
      body: DriverScreenStateHost(
        status: widget.status,
        emptyTitle: l10n.dr_good_morning(name),
        emptyMessage: l10n.dr03_empty,
        errorTitle: l10n.dr_good_morning(name),
        errorMessage: l10n.dr03_error,
        retryLabel: l10n.retry,
        successAnnouncement: l10n.dr03_success,
        child: ListView(
          children: [
            const TTGap.xl(),
            Row(
              children: [
                StatusChip(
                  style: StatusStyle.active,
                  label: l10n.dr_ready_online,
                ),
                const TTGap.md(axis: Axis.horizontal),
                SyncBadge(
                  state: online ? SyncState.synced : SyncState.pending,
                  label: online ? l10n.synced : l10n.pendingSync,
                ),
              ],
            ),
            const TTGap.lg(),
            TTStepper(
              steps: [
                l10n.dr_verify_title,
                l10n.dr_start_shift,
                l10n.tab_tasks,
              ],
              current: 1,
            ),
            const TTGap.lg(),
            TTCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle.name, style: context.text.titleLarge),
                  const TTGap.xs(),
                  Text(vehicle.plate, style: context.text.bodyMedium),
                  const TTGap.xs(),
                  Text(vehicle.shiftWindow, style: context.text.bodyMedium),
                  const TTGap.md(),
                  QuantityBadge(
                    primary:
                        '${vehicle.capacityIg.toStringAsFixed(0)} IG',
                    secondary:
                        '${vehicle.onboardIg.toStringAsFixed(0)} IG',
                  ),
                ],
              ),
            ),
            const TTGap.lg(),
            TTTextField(
              label: l10n.dr_odometer,
              controller: _odometer,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => setState(() {}),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9\\s,]')),
              ],
            ),
            if (reading == null || decreased) const TTGap.sm(),
            if (reading == null)
              Text(l10n.requiredField, style: context.text.bodyMedium)
            else if (decreased)
              Text(
                l10n.dr_odometer_error,
                style: context.text.bodyMedium
                    ?.copyWith(color: context.status.critical),
              ),
            const TTGap.md(),
            CheckboxListTile(
              value: _consent,
              onChanged: (v) => setState(() => _consent = v ?? false),
              title: Text(l10n.dr_location_consent),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const TTGap.xl(),
          ],
        ),
      ),
      bottomBar: TTStickyBottomBar(
        ctaLabel: l10n.dr_confirm_vehicle,
        onCta: ready ? _start : null,
      ),
    );
  }
}
