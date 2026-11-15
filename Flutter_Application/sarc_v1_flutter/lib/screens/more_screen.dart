import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'about_data_screen.dart';
import 'notifications_screen.dart';
import 'report_screen.dart';
import 'safety_guide_screen.dart';
import 'settings_screen.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ListenableBuilder(
            listenable: notificationStore,
            builder: (context, _) => _item(
              context,
              icon: Icons.notifications_outlined,
              title: 'Notification history',
              subtitle: notificationStore.unread == 0
                  ? 'All read'
                  : '${notificationStore.unread} unread',
              screen: const NotificationsScreen(),
            ),
          ),
          const SizedBox(height: 10),
          _item(
            context,
            icon: Icons.shield_outlined,
            title: 'Safety guide',
            subtitle: 'Before, during and after a river hazard',
            screen: const SafetyGuideScreen(),
          ),
          const SizedBox(height: 10),
          _item(
            context,
            icon: Icons.edit_note,
            title: 'Report an observation',
            subtitle: 'Share what you see with the monitoring team',
            screen: const ReportScreen(),
          ),
          const SizedBox(height: 10),
          _item(
            context,
            icon: Icons.satellite_alt,
            title: 'About and data',
            subtitle: 'Sources, study area and limitations',
            screen: const AboutDataScreen(),
          ),
          const SizedBox(height: 10),
          _item(
            context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Text size, language, privacy',
            screen: const SettingsScreen(),
          ),
          const DisclaimerFooter(),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget screen,
  }) {
    return SarcCard(
      onTap: () => _open(context, screen),
      child: Row(
        children: [
          Icon(icon, color: SarcColors.blue),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: SarcColors.navy,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: SarcColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: SarcColors.textMuted),
        ],
      ),
    );
  }
}
