import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../utils/format.dart';
import '../widgets/common_widgets.dart';
import 'advisory_detail_screen.dart';
import '../core/i18n.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notificationStore,
      builder: (context, _) {
        final items = notificationStore.items;
        return Scaffold(
          appBar: AppBar(
            title: const Tr('Notification history'),
            actions: [
              TextButton(
                onPressed:
                    notificationStore.unread == 0 ? null : notificationStore.markAllRead,
                child: const Tr('Mark all read'),
              ),
            ],
          ),
          body: items.isEmpty
              ? const EmptyState(
                  icon: Icons.notifications_none,
                  title: 'No notifications yet',
                  message: 'Advisories for your area will appear here once '
                      'they are published.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    if (i == items.length) return const DisclaimerFooter();
                    final n = items[i];
                    return SarcCard(
                      color: n.read ? null : SarcColors.infoBg,
                      onTap: () {
                        notificationStore.markRead(n.id);
                        final adv = AppData.advisoryById(n.advisoryId);
                        if (adv != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AdvisoryDetailScreen(advisory: adv),
                            ),
                          );
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(n.level.icon, color: n.level.color),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tr(
                                  n.title,
                                  style: TextStyle(
                                    fontWeight: n.read
                                        ? FontWeight.w600
                                        : FontWeight.w800,
                                    color: SarcColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Tr(
                                  n.body,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: SarcColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    LevelBadge(n.level),
                                    const Spacer(),
                                    Tr(
                                      timeAgo(n.time),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: SarcColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
