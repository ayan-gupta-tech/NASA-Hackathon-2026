import 'package:flutter/material.dart';

import '../state/app_state.dart';
import 'advisories_screen.dart';
import 'emergency_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'more_screen.dart';
import '../core/i18n.dart';

/// Holds the bottom navigation bar and the five main tabs.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _goToTab(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(onGoToTab: _goToTab),
      const MapScreen(),
      const AdvisoriesScreen(),
      const EmergencyScreen(),
      const MoreScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: ListenableBuilder(
        listenable: notificationStore,
        builder: (context, _) => NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _goToTab,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home'.tr,
            ),
            NavigationDestination(
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map),
              label: 'Map'.tr,
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: notificationStore.unread > 0,
                label: Tr('${notificationStore.unread}'),
                child: const Icon(Icons.campaign_outlined),
              ),
              selectedIcon: const Icon(Icons.campaign),
              label: 'Advisories'.tr,
            ),
            NavigationDestination(
              icon: Icon(Icons.phone_in_talk_outlined),
              selectedIcon: Icon(Icons.phone_in_talk),
              label: 'Emergency'.tr,
            ),
            NavigationDestination(
              icon: Icon(Icons.menu),
              label: 'More'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
