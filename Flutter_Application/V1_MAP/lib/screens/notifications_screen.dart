import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../utils/format.dart';
import '../widgets/common_widgets.dart';
import 'advisory_detail_screen.dart';

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
            title: const Text('Notification history'),
            actions: [
              TextButton(
                onPressed:
                    notificationStore.unread == 0 ? null : notificationStore.markAllRead,
                child: const Text('Mark all read'),
              ),
            ],
          ),
          body: items.isEmpty
              ? const Center(child: Text('No notifications yet.'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    if (i == items.length) return const DisclaimerFooter();
                    final n = items[i];
                    return SarcCard(
                      color: n.read ? null : const Color(0xFFEAF3FC),
                      onTap: () {
                        notificationStore.markRead(n.id);
                        final adv = MockData.advisoryById(n.advisoryId);
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
                                Text(
                                  n.title,
                                  style: TextStyle(
                                    fontWeight: n.read
                                        ? FontWeight.w600
                                        : FontWeight.w800,
                                    color: SarcColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  n.body,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: SarcColors.textMuted,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    LevelBadge(n.level),
                                    const Spacer(),
                                    Text(
                                      timeAgo(n.time),
                                      style: const TextStyle(
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
