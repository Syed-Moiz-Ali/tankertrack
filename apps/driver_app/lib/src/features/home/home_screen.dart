import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import 'messages_tab.dart';
import 'profile_tab.dart';
import 'tasks_tab.dart';
import 'today_tab.dart';

/// Driver tab shell (P1b): Today / Tasks / Messages / Profile.
///
/// Tabs are in-app local state; go_router routes (/home, /login, /design)
/// are untouched. The bottom bar is a theme-styled [NavigationBar]
/// stand-in with the TTBottomTabBar API shape (tabs/index/onTap) until the
/// shared TTBottomTabBar lands in design_system (ui-components slice).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _index = 0;

  static const _pages = [
    TodayTab(),
    TasksTab(),
    MessagesTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return TTScaffold(
      body: _pages[_index],
      bottomBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: Icon(AppIcons.iconFor(AppIcons.dashboard, context)),
            label: l10n.tab_today,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.iconFor(AppIcons.pod, context)),
            label: l10n.tab_tasks,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.iconFor(AppIcons.message, context)),
            label: l10n.tab_messages,
          ),
          NavigationDestination(
            icon: Icon(AppIcons.iconFor(AppIcons.user, context)),
            label: l10n.tab_profile,
          ),
        ],
      ),
    );
  }
}
