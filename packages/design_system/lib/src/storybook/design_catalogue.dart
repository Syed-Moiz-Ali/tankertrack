import 'package:flutter/material.dart';

import '../components/tt_bars.dart';
import '../components/tt_button.dart';
import '../components/tt_calendar.dart';
import '../components/tt_card.dart';
import '../components/tt_cards.dart';
import '../components/tt_carousel.dart';
import '../components/tt_category_bar.dart';
import '../components/tt_charts.dart';
import '../components/tt_command.dart';
import '../components/tt_dispatch.dart';
import '../components/tt_dropdown.dart';
import '../components/tt_empty_state.dart';
import '../components/tt_error_state.dart';
import '../components/tt_gap.dart';
import '../components/tt_hero.dart';
import '../components/tt_icon_button.dart';
import '../components/tt_image_grid.dart';
import '../components/tt_kpi.dart';
import '../components/tt_kpi_card.dart';
import '../components/tt_media_card.dart';
import '../components/tt_profile_menu.dart';
import '../components/tt_progress.dart';
import '../components/tt_rows.dart';
import '../components/tt_scaffold.dart';
import '../components/tt_search_pill.dart';
import '../components/tt_section_header.dart';
import '../components/tt_segmented_tabs.dart';
import '../components/tt_sheets.dart';
import '../components/tt_skeleton.dart';
import '../components/tt_stat.dart';
import '../components/tt_status_chip.dart';
import '../components/tt_stepper.dart';
import '../components/tt_sticky.dart';
import '../components/tt_tab_bar.dart';
import '../components/tt_text_field.dart';
import '../components/tt_timeline.dart';
import '../components/tt_topbar.dart';
import '../components/tt_topnav.dart';
import '../context_ext.dart';
import '../icons.dart';
import '../status_colors.dart';

/// Localized labels for the catalogue. The hosting app passes
/// `context.l10n` values — the catalogue itself holds zero strings.
class DesignStrings {
  const DesignStrings({
    required this.components,
    required this.buttons,
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.fields,
    required this.searchHint,
    required this.chips,
    required this.quantities,
    required this.sync,
    required this.cards,
    required this.banners,
    required this.states,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.errorTitle,
    required this.errorMessage,
    required this.retry,
    required this.flow,
    this.navigation = 'Navigation',
    this.searchPill = 'Search pill',
    this.categories = 'Categories',
    this.segmented = 'Segments',
    this.profileMenu = 'Profile menu',
    this.media = 'Media cards',
    this.gallery = 'Photo grid',
    this.sticky = 'Sticky cards & bars',
    this.bottomTabs = 'Bottom tabs',
    this.sheets = 'Sheets',
    this.carousel = 'Carousel',
    this.kpis = 'KPIs & sparklines',
    this.charts = 'Charts',
    this.headers = 'Section headers',
    this.topBar = 'Top bar',
    this.commandPalette = 'Command palette',
    this.sideSheet = 'Side sheet & split view',
    this.heroMap = 'Hero map & live ops',
    this.stats = 'Stats & pills',
    this.listRows = 'List rows',
    this.entityCards = 'Entity cards',
    this.dispatch = 'Dispatch match',
    this.validation = 'Validation sheet',
    this.stepProgress = 'Step progress',
    this.allocation = 'Allocation bar',
    this.bottomBar = 'Bottom action bar',
    this.screenStates = 'Screen states',
    this.overlays = 'Timeout & about',
  });

  final String components;
  final String buttons;
  final String primary;
  final String secondary;
  final String tertiary;
  final String fields;
  final String searchHint;
  final String chips;
  final String quantities;
  final String sync;
  final String cards;
  final String banners;
  final String states;
  final String emptyTitle;
  final String emptyMessage;
  final String errorTitle;
  final String errorMessage;
  final String retry;
  final String flow;

  /// P1b Airbnb-reference sections. Optional with demo defaults so existing
  /// call sites (apps, goldens) keep compiling; the hosting app passes
  /// localized values once ARB keys land.
  final String navigation;
  final String searchPill;
  final String categories;
  final String segmented;
  final String profileMenu;
  final String media;
  final String gallery;
  final String sticky;
  final String bottomTabs;
  final String sheets;
  final String carousel;
  final String kpis;
  final String charts;
  final String headers;

  /// R3 Calm Control sections (ui-components slice). Optional with demo
  /// defaults; the catalogue is lint-exempt and holds literal demo strings.
  final String topBar;
  final String commandPalette;
  final String sideSheet;
  final String heroMap;
  final String stats;
  final String listRows;
  final String entityCards;
  final String dispatch;
  final String validation;
  final String stepProgress;
  final String allocation;
  final String bottomBar;
  final String screenStates;
  final String overlays;
}

/// Storybook catalogue: every TT* component on one scrollable page.
/// Rendered in goldens across light/dark × LTR/RTL × driver/web/controlRoom.
class DesignCatalogue extends StatelessWidget {
  const DesignCatalogue({super.key, required this.strings});

  final DesignStrings strings;

  @override
  Widget build(BuildContext context) {
    return TTScaffold(
      appBar: TTAppBar(title: strings.components),
      body: ListView(
        children: [
          const TTGap.lg(),
          TTSection(
            title: strings.buttons,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TTButton(label: strings.primary, onPressed: () {}),
                const TTGap.sm(),
                TTButton(
                  label: strings.secondary,
                  variant: TTButtonVariant.secondary,
                  onPressed: () {},
                ),
                const TTGap.sm(),
                TTButton(
                  label: strings.tertiary,
                  variant: TTButtonVariant.tertiary,
                  onPressed: () {},
                ),
                const TTGap.sm(),
                Row(
                  children: [
                    TTIconButton(
                      icon: Icon(
                        AppIcons.iconFor(AppIcons.add, context),
                      ),
                      onPressed: () {},
                    ),
                    const TTChip(label: 'Demo'),
                  ],
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.fields,
            child: Column(
              children: [
                const TTTextField(),
                const TTGap.md(),
                TTSearchBar(hint: strings.searchHint),
                const TTGap.md(),
                const TTFilterPills(
                  options: ['A', 'B', 'C'],
                  selected: 'A',
                  onSelected: _noop,
                ),
                const TTGap.md(),
                TTNumberStepperField(
                  label: 'IG',
                  value: 1500,
                  onChanged: (_) {},
                  display: '1,500.0 IG',
                ),
                const TTGap.md(),
                TTDropdown<String>(
                  label: 'Demo',
                  value: 'A',
                  items: const [
                    TTDropdownItem(value: 'A', label: 'A'),
                    TTDropdownItem(value: 'B', label: 'B'),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.chips,
            child: Wrap(
              spacing: context.tokens.spaceSm,
              runSpacing: context.tokens.spaceSm,
              children: const [
                StatusChip(style: StatusStyle.completed, label: 'Completed'),
                StatusChip(style: StatusStyle.active, label: 'Active'),
                StatusChip(style: StatusStyle.loading, label: 'Loading'),
                StatusChip(style: StatusStyle.unloading, label: 'Unloading'),
                StatusChip(style: StatusStyle.waiting, label: 'Waiting'),
                StatusChip(style: StatusStyle.critical, label: 'Critical'),
                StatusChip(style: StatusStyle.offline, label: 'Offline'),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.quantities,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuantityBadge(primary: '4,000 IG', secondary: '18,184 L'),
                QuantityBadge(
                  primary: '2,500 IG',
                  state: QuantityState.warn,
                ),
                QuantityBadge(
                  primary: '−120 IG',
                  state: QuantityState.breach,
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.sync,
            child: const Row(
              children: [
                SyncBadge(state: SyncState.pending, label: 'Pending'),
                SyncBadge(state: SyncState.synced, label: 'Synced'),
                SyncBadge(state: SyncState.failed, label: 'Failed'),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.cards,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TTKpiCard(
                        label: 'Orders',
                        value: '110',
                        sub: '+12%',
                        icon: Icon(
                          AppIcons.iconFor(AppIcons.report, context),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TTKpiCard(label: 'IG', value: '48.2K'),
                    ),
                  ],
                ),
                const TTGap.md(),
                TTCard(
                  child: TTListTile(
                    leading: const TTAvatar(initials: 'KA'),
                    title: 'Khalid Al-Otaibi',
                    subtitle: 'T-214 · 4,000 IG',
                    trailing: Icon(
                      AppIcons.iconFor(AppIcons.forward, context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.banners,
            child: Column(
              children: [
                TTBanner(message: strings.states, kind: TTBannerKind.info),
                TTBanner(message: strings.states, kind: TTBannerKind.warning),
                TTBanner(message: strings.states, kind: TTBannerKind.offline),
                TTBanner(
                  message: strings.states,
                  kind: TTBannerKind.tracking,
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.states,
            child: Column(
              children: [
                TTEmptyState(
                  title: strings.emptyTitle,
                  message: strings.emptyMessage,
                ),
                const TTGap.md(),
                TTErrorState(
                  title: strings.errorTitle,
                  message: strings.errorMessage,
                  retryLabel: strings.retry,
                ),
                const TTGap.md(),
                const TTSkeleton(rows: 3),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.flow,
            child: const Column(
              children: [
                TTStepper(steps: ['One', 'Two', 'Three'], current: 1),
                TTTimeline(
                  entries: [
                    TTTimelineEntry(title: 'Start Day', subtitle: '07:00'),
                    TTTimelineEntry(title: 'Loaded', subtitle: '08:05'),
                  ],
                ),
                TTMonthCalendar(
                  year: 2026,
                  month: 10,
                  commitments: {5: 2, 12: 1, 23: 3},
                  weekdayLabels: ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.navigation,
            child: TTTopNav(
              tabs: const [
                TTNavTabData(label: 'Today', icon: AppIcons.dashboard),
                TTNavTabData(
                  label: 'Fleet',
                  icon: AppIcons.truck,
                  badgeCount: 2,
                ),
                TTNavTabData(label: 'Customers', icon: AppIcons.customer),
              ],
              selectedIndex: 0,
              onSelect: _noopInt,
              trailing: TTIconCircleButton(
                icon: AppIcons.user,
                onPressed: () {},
              ),
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.searchPill,
            child: Column(
              children: [
                TTSearchPill(
                  segments: const [
                    TTSearchSegment(label: 'Where', value: 'Riyadh depot'),
                    TTSearchSegment(label: 'When', value: 'This week'),
                    TTSearchSegment(label: 'What', value: 'Diesel'),
                  ],
                  searchLabel: 'Search',
                  onTapSegment: _noopInt,
                  onSearch: () {},
                ),
                const TTGap.md(),
                TTSearchPill(
                  compact: true,
                  segments: const [
                    TTSearchSegment(label: 'Where', value: 'Riyadh'),
                    TTSearchSegment(label: 'When', value: 'Anytime'),
                    TTSearchSegment(label: 'Who', value: 'Add drivers'),
                  ],
                  searchLabel: 'Search',
                  onTapSegment: _noopInt,
                  onSearch: () {},
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.categories,
            child: TTCategoryBar(
              items: const [
                TTCategoryItem(icon: AppIcons.truck, label: 'Tankers'),
                TTCategoryItem(icon: AppIcons.depot, label: 'Depots'),
                TTCategoryItem(icon: AppIcons.customer, label: 'Customers'),
                TTCategoryItem(icon: AppIcons.route, label: 'Routes'),
              ],
              selected: 0,
              onSelect: _noopInt,
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.segmented,
            child: TTSegmentedTabs(
              tabs: const [
                TTCountTab(label: 'Loading now', count: 3),
                TTCountTab(label: 'In transit', count: 12),
                TTCountTab(label: 'Arriving soon', count: 5),
              ],
              selected: 1,
              onSelect: _noopInt,
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.headers,
            child: Column(
              children: [
                const TTSectionHeader(
                  title: 'Fleet today',
                  actionLabel: 'Show all',
                ),
                const TTGap.md(),
                TTSectionHeader(title: 'Nearby depots', onAction: () {}),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.media,
            child: Row(
              children: [
                Expanded(
                  child: TTMediaCard(
                    image: _DemoImage(icon: AppIcons.truck, label: 'T-214'),
                    title: 'T-214 · Riyadh',
                    subtitle: '4,000 IG · Diesel',
                    figure: 'SAR 12,400',
                    badge: 'Available',
                    saved: true,
                    onSave: () {},
                    onTap: () {},
                  ),
                ),
                const TTGap.md(axis: Axis.horizontal),
                Expanded(
                  child: TTMediaCard(
                    image: _DemoImage(icon: AppIcons.depot, label: 'D-03'),
                    title: 'D-03 · Jeddah',
                    subtitle: '2,500 IG · Petrol',
                    figure: 'SAR 8,100',
                    badge: 'Standby',
                    onSave: () {},
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.carousel,
            child: TTCarousel(
              itemWidth: 220,
              children: const [
                TTCard(child: Text('Stop 1 · Loading')),
                TTCard(child: Text('Stop 2 · En route')),
                TTCard(child: Text('Stop 3 · Unloading')),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.gallery,
            child: TTImageGrid(
              images: const [
                _DemoImage(icon: AppIcons.truck, label: 'Hero'),
                _DemoImage(icon: AppIcons.photo, label: 'Side'),
                _DemoImage(icon: AppIcons.photo, label: 'Cab'),
                _DemoImage(icon: AppIcons.photo, label: 'Tank'),
                _DemoImage(icon: AppIcons.photo, label: 'Rear'),
              ],
              showAllLabel: 'Show all photos',
              onShowAll: () {},
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.sticky,
            child: Column(
              children: [
                const TTStickyActionCard(
                  child: Text('SAR 12,400 · Pay on delivery'),
                ),
                const TTGap.md(),
                TTStickyBottomBar(
                  number: '48,200 IG',
                  caption: 'Today · 12 stops',
                  ctaLabel: 'Dispatch',
                  onCta: () {},
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.kpis,
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: TTCard(
                        child: TTKpiTile(
                          icon: AppIcons.truck,
                          value: '110',
                          caption: 'Active trips',
                          trend: '+12% vs yesterday',
                        ),
                      ),
                    ),
                    Expanded(
                      child: TTCard(
                        child: TTKpiTile(
                          icon: AppIcons.incident,
                          value: '3',
                          caption: 'Needs attention',
                          trend: '-1 resolved today',
                        ),
                      ),
                    ),
                  ],
                ),
                const TTGap.md(),
                const TTCard(
                  child: TTSparkline(values: [1, 3, 2, 5, 4, 6]),
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.charts,
            child: Column(
              children: const [
                TTStackedBar(
                  segments: [
                    TTBarSegment(
                      label: 'Completed',
                      value: 62,
                      style: StatusStyle.completed,
                    ),
                    TTBarSegment(
                      label: 'Active',
                      value: 24,
                      style: StatusStyle.active,
                    ),
                    TTBarSegment(
                      label: 'Waiting',
                      value: 14,
                      style: StatusStyle.waiting,
                    ),
                  ],
                ),
                TTGap.md(),
                TTDonut(
                  segments: [
                    TTBarSegment(
                      label: 'Diesel',
                      value: 70,
                      style: StatusStyle.completed,
                    ),
                    TTBarSegment(
                      label: 'Petrol',
                      value: 20,
                      style: StatusStyle.active,
                    ),
                    TTBarSegment(
                      label: 'Kerosene',
                      value: 10,
                      style: StatusStyle.waiting,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.bottomTabs,
            child: TTBottomTabBar(
              tabs: const [
                TTBottomTab(icon: AppIcons.dashboard, label: 'Today'),
                TTBottomTab(icon: AppIcons.truck, label: 'Tasks'),
                TTBottomTab(icon: AppIcons.message, label: 'Messages'),
                TTBottomTab(icon: AppIcons.user, label: 'Profile'),
              ],
              index: 0,
              onTap: _noopInt,
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.sheets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TTButton(
                  label: 'Open grabber sheet',
                  onPressed: () => showTTGrabberSheet(
                    context,
                    const Text('Grabber sheet body'),
                  ),
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.topBar,
            child: TTTopBar(
              items: const [
                TTTopBarItem(label: 'Today', icon: AppIcons.dashboard),
                TTTopBarItem(label: 'Orders', icon: AppIcons.pod),
                TTTopBarItem(
                  label: 'Dispatch',
                  icon: AppIcons.route,
                  badgeCount: 3,
                ),
                TTTopBarItem(label: 'Live', icon: AppIcons.map),
                TTTopBarItem(label: 'Fleet', icon: AppIcons.truck),
                TTTopBarItem(label: 'More', icon: AppIcons.settings),
              ],
              selectedIndex: 0,
              onSelect: _noopInt,
              commandHint: 'Search orders, trips, drivers…',
              shortcutHint: 'Ctrl K',
              onCommand: () {},
              hasNotifications: true,
              notificationsLabel: 'Notifications',
              onNotifications: () {},
              profileLabel: 'OP',
              profileTooltip: 'Omar Planner',
              onProfile: () {},
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.commandPalette,
            child: TTCommandPalette(
              hint: 'Search orders, trips, drivers…',
              noResults: 'No results — try another search.',
              shortcutHint: 'Up and down to navigate · Enter to select',
              onSelect: (_) {},
              items: const [
                TTCommandItem(
                  title: 'SO-260145 · ABC Trading',
                  subtitle: 'Order · 3,520 IG',
                  icon: AppIcons.pod,
                ),
                TTCommandItem(
                  title: 'Ahmed Khan',
                  subtitle: 'Driver · Tanker 07',
                  icon: AppIcons.user,
                ),
                TTCommandItem(
                  title: 'Tanker 04 · Pump failure',
                  subtitle: 'Incident · Jebel Ali',
                  icon: AppIcons.breakdown,
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.sideSheet,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TTSideSheet(
                  title: 'SO-260145 · ABC Trading',
                  openFullPageLabel: 'Open full page',
                  onOpenFullPage: () {},
                  child: const Text('Tanker 07 · Ahmed Khan · 3,520 IG'),
                ),
                const TTGap.md(),
                SizedBox(
                  height: 220,
                  child: TTSplitView(
                    listPane: const Text('Orders list'),
                    detailPane: const Text('Order detail'),
                  ),
                ),
                const TTGap.md(),
                TTButton(
                  label: 'Open side sheet',
                  onPressed: () => showTTSideSheet(
                    context,
                    title: 'SO-260145 · ABC Trading',
                    openFullPageLabel: 'Open full page',
                    child: const Text('Tanker 07 · Ahmed Khan · 3,520 IG'),
                  ),
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.heroMap,
            child: TTHeroMap(
              map: const _DemoImage(icon: AppIcons.map, label: 'Live map'),
              liveOps: const TTLiveOpsInfo(
                title: 'Live operations · 28 active',
                etaLabel: 'ETA',
                etaValue: '10:42',
                distanceLabel: 'Distance',
                distanceValue: '16.4 km',
                remainingLabel: 'Remaining',
                remainingValue: '3,520 IG',
                viewLabel: 'View',
              ),
              onViewLiveOps: () {},
              stats: const [
                TTStatData(label: 'Orders today', value: '87'),
                TTStatData(label: 'Active trips', value: '28'),
                TTStatData(label: 'Delayed', value: '4'),
                TTStatData(label: 'Breakdowns', value: '1'),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.stats,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TTStatStrip(
                  stats: const [
                    TTStatData(label: 'Loaded', value: '78,500 IG'),
                    TTStatData(label: 'Delivered', value: '46,250 IG'),
                    TTStatData(label: 'Variance', value: '125 IG'),
                    TTStatData(label: 'Delayed', value: '4'),
                  ],
                ),
                const TTGap.md(),
                Wrap(
                  spacing: context.tokens.spaceSm,
                  runSpacing: context.tokens.spaceSm,
                  children: const [
                    TTStatusPill(style: StatusStyle.active, label: 'In transit'),
                    TTStatusPill(style: StatusStyle.loading, label: 'Loading'),
                    TTStatusPill(
                      style: StatusStyle.critical,
                      label: 'Delayed',
                      icon: AppIcons.breakdown,
                    ),
                    TTStatusPill(style: StatusStyle.waiting, label: 'Waiting'),
                  ],
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.listRows,
            child: Column(
              children: [
                TTListRow(
                  title: 'Ahmed Khan · DRV-0028',
                  subtitle: 'Tanker 07 · 3,520 IG · ETA 10:42',
                  initials: 'AK',
                  style: StatusStyle.active,
                  pillLabel: 'In transit',
                  onTap: () {},
                ),
                const TTGap.sm(),
                TTListRow(
                  title: 'Tanker 04 · Pump failure',
                  subtitle: 'Jebel Ali · Rashid Kareem',
                  initials: 'RK',
                  style: StatusStyle.critical,
                  pillLabel: 'Breakdown',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.entityCards,
            child: Column(
              children: [
                TTEntityCard(
                  title: 'ABC Trading · SO-260145',
                  subtitle: 'Industrial City · Diesel 10ppm',
                  details: const [
                    '3,520 IG · E11 route · 16.4 km',
                    'Telemetry 3,520 IG · variance 0 IG',
                  ],
                  statusStyle: StatusStyle.active,
                  statusLabel: 'In transit',
                  onTap: () {},
                ),
                const TTGap.md(),
                TTEntityCard(
                  title: 'Rashid Kareem · Tanker 04',
                  subtitle: 'Pump failure · Jebel Ali depot',
                  statusStyle: StatusStyle.critical,
                  statusLabel: 'Breakdown',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.dispatch,
            child: TTMatchColumn(
              title: 'Best matches · XYZ Retailer',
              hint: '2,000 IG · Investment Park',
              candidates: const [
                TTMatchCandidate(
                  title: 'Tanker 07 · Ahmed Khan',
                  subtitle: '4.2 km away · 3,600 IG available',
                  scoreLabel: '98',
                ),
                TTMatchCandidate(
                  title: 'Tanker 12 · Omar Farouk',
                  subtitle: '9.8 km away · 2,400 IG available',
                  scoreLabel: '84',
                  note: 'Needs refuelling after this drop',
                ),
              ],
              selectedIndex: 0,
              onSelect: _noopInt,
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.validation,
            child: TTValidationSheet(
              title: 'Validate TRIP-260021',
              summary: '5,000 IG · Diesel 10ppm · 3 drops',
              confirmLabel: 'Confirm dispatch',
              cancelLabel: 'Back',
              onConfirm: () {},
              checks: const [
                TTValidationCheck(
                  label: 'Vehicle capacity covers load',
                  detail: '5,000 of 6,000 IG',
                  passed: true,
                ),
                TTValidationCheck(
                  label: 'Driver shift is active',
                  detail: 'Ahmed Khan · on shift since 06:00',
                  passed: true,
                ),
                TTValidationCheck(
                  label: 'Depot stock available',
                  detail: 'Short by 500 IG at Jebel Ali',
                  passed: false,
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.stepProgress,
            child: const TTStepProgress(
              current: 1,
              steps: [
                TTStepData(label: 'Verify', caption: 'Face check'),
                TTStepData(label: 'Vehicle', caption: 'Tanker 07'),
                TTStepData(label: 'Start shift', caption: '06:00 GST'),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.allocation,
            child: const TTAllocationBar(
              totalLabel: 'TRIP-260021 · 5,000 IG',
              totalValue: '5,000 IG',
              segments: [
                TTAllocationSegment(
                  label: 'ABC Trading · 1,500 IG',
                  value: 1500,
                  style: StatusStyle.completed,
                ),
                TTAllocationSegment(
                  label: 'XYZ Retailer · 2,000 IG',
                  value: 2000,
                  style: StatusStyle.active,
                ),
                TTAllocationSegment(
                  label: 'Delta Foods · 1,500 IG',
                  value: 1500,
                  style: StatusStyle.loading,
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.bottomBar,
            child: TTBottomActionBar(
              title: 'TRIP-260021 · 5,000 IG',
              caption: '3 drops · 126 km · Diesel 10ppm',
              secondaryLabel: 'Save draft',
              onSecondary: () {},
              primaryLabel: 'Confirm dispatch',
              onPrimary: () {},
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.screenStates,
            child: Column(
              children: [
                SizedBox(
                  height: 240,
                  child: ScreenStateHost(
                    state: ScreenStateKind.empty,
                    emptyTitle: 'No orders yet',
                    emptyMessage: 'Orders for today appear here.',
                    loadingLabel: 'Loading orders…',
                    errorTitle: 'Orders failed to load',
                    errorMessage: 'Check your connection and retry.',
                    retryLabel: 'Retry',
                    onRetry: () {},
                    demoTitle: 'Demo state',
                    demoLabels: const {
                      ScreenStateKind.empty: 'Empty',
                      ScreenStateKind.loading: 'Loading',
                      ScreenStateKind.error: 'Error',
                      ScreenStateKind.success: 'Success',
                    },
                    onDemoSelect: (_) {},
                    child: const Text('87 orders'),
                  ),
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.overlays,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TTIdleTimeoutDialog(
                  title: 'Still there?',
                  countdownLabel: 'Signing out in 1:24 for security.',
                  stayLabel: 'Stay signed in',
                  signOutLabel: 'Sign out now',
                  onStay: null,
                  onSignOut: null,
                ),
                const TTGap.md(),
                const TTAboutDialog(
                  title: 'About TankerTrack',
                  message: 'Fuel distribution, calmly under control.',
                  photoCredits: 'Photos: licensed UAE depot imagery.',
                  closeLabel: 'Close',
                  onClose: null,
                ),
              ],
            ),
          ),
          const TTGap.xl(),
          TTSection(
            title: strings.profileMenu,
            child: TTProfileMenuButton(
              avatarLabel: 'OP',
              sheetTitle: 'Omar · Profile',
              themeMode: ThemeMode.system,
              onTheme: (_) {},
              lightLabel: 'Light',
              darkLabel: 'Dark',
              systemLabel: 'System',
              locale: const Locale('en'),
              onLocale: (_) {},
              englishLabel: 'English',
              arabicLabel: 'Arabic',
              roleEntries: const [
                TTMenuRole(value: 'dispatcher', label: 'Dispatcher'),
                TTMenuRole(value: 'manager', label: 'Manager'),
              ],
              currentRole: 'dispatcher',
              onRole: (_) {},
              demoRoleLabel: 'Demo role',
              signOutLabel: 'Sign out',
              onSignOut: () {},
              profileLabel: 'Omar Planner',
            ),
          ),
          const TTGap.xxxl(),
        ],
      ),
    );
  }
}

void _noop(String _) {}

void _noopInt(int _) {}

/// Themed demo image block for catalogue cards/grids (lint-exempt demo).
class _DemoImage extends StatelessWidget {
  const _DemoImage({required this.icon, required this.label});

  final AppIcon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      color: c.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.iconFor(icon, context),
              color: c.onSurfaceVariant,
              size: context.tokens.iconLg,
            ),
            Text(label, style: context.text.bodySmall),
          ],
        ),
      ),
    );
  }
}
