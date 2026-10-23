import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l10n/l10n.dart';

import '../../providers.dart';
import 'messages_tab.dart';
import 'profile_tab.dart';
import 'tasks_tab.dart';
import 'today_tab.dart';

/// Driver tab shell: Today / Tasks / Messages / Profile (existing ARB keys
/// `tab_today/tab_tasks/tab_messages/tab_profile` — see slice return for the
/// Figma Home/Tasks/Activity/Support mismatch note).
///
/// Tabs are in-app local state; go_router routes are untouched. The bar is
/// the shared [TTBottomTabBar]; the [TTScaffold] banner slot carries the
/// offline indicator in the same visual language as the screens.
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
    final online = ref.watch(connectionProvider);
    return TTScaffold(
      body: _pages[_index],
      banner: online
          ? null
          : TTBanner(message: l10n.offline, kind: TTBannerKind.offline),
      bottomBar: TTBottomTabBar(
        tabs: [
          TTBottomTab(icon: AppIcons.dashboard, label: l10n.tab_today),
          TTBottomTab(icon: AppIcons.pod, label: l10n.tab_tasks),
          TTBottomTab(icon: AppIcons.message, label: l10n.tab_messages),
          TTBottomTab(icon: AppIcons.user, label: l10n.tab_profile),
        ],
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}
