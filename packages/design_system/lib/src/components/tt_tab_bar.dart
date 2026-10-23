import 'package:flutter/material.dart';

import '../icons.dart';

/// One bottom tab: semantic icon + localized label.
@immutable
class TTBottomTab {
  const TTBottomTab({required this.icon, required this.label});

  final AppIcon icon;
  final String label;
}

/// Driver mobile shell bar (Today / Tasks / Messages / Profile): M3
/// [NavigationBar] so the look comes from the surface theme (driver theme
/// raises the bar height). Destination order auto-mirrors in RTL.
class TTBottomTabBar extends StatelessWidget {
  const TTBottomTabBar({
    super.key,
    required this.tabs,
    required this.index,
    required this.onTap,
  });

  final List<TTBottomTab> tabs;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) return const SizedBox.shrink();
    final clamped = index.clamp(0, tabs.length - 1);
    return NavigationBar(
      selectedIndex: clamped,
      onDestinationSelected: onTap,
      destinations: <Widget>[
        for (final tab in tabs)
          NavigationDestination(
            icon: Icon(AppIcons.iconFor(tab.icon, context)),
            label: tab.label,
          ),
      ],
    );
  }
}
