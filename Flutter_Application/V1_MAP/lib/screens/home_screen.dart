import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/mock_data.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'advisory_detail_screen.dart';
import 'notifications_screen.dart';
import 'report_screen.dart';
import 'safety_guide_screen.dart';

class HomeScreen extends StatelessWidget {
  /// Lets quick-action tiles switch the bottom-navigation tab.
  /// Tab indexes: 0 Home, 1 Map, 2 Advisories, 3 Emergency, 4 More.
  final ValueChanged<int> onGoToTab;

  const HomeScreen({super.key, required this.onGoToTab});

  @override
  Widget build(BuildContext context) {
    final latest = MockData.advisories.take(2).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            AppConst.logoSymbol,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.satellite_alt, color: SarcColors.navy),
          ),
        ),
        title: const Text('SARC'),
        actions: [
          ListenableBuilder(
            listenable: notificationStore,
            builder: (context, _) => IconButton(
              tooltip: 'Notifications',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
              icon: Badge(
                isLabelVisible: notificationStore.unread > 0,
                label: Text('${notificationStore.unread}'),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const DemoBanner(),
          const SizedBox(height: 14),
          const _StatusCard(),
          const SectionHeader('Quick actions'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.55,
            children: [
              _ActionTile(
                icon: Icons.map_outlined,
                label: 'View map',
                onTap: () => onGoToTab(1),
              ),
              _ActionTile(
                icon: Icons.shield_outlined,
                label: 'Safety guide',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SafetyGuideScreen()),
                ),
              ),
              _ActionTile(
                icon: Icons.phone_in_talk_outlined,
                label: 'Emergency contacts',
                onTap: () => onGoToTab(3),
              ),
              _ActionTile(
                icon: Icons.edit_note,
                label: 'Report observation',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ReportScreen()),
                ),
              ),
            ],
          ),
          SectionHeader(
            'Latest updates',
            actionLabel: 'See all',
            onAction: () => onGoToTab(2),
          ),
          for (final a in latest) ...[
            AdvisoryCard(
              advisory: a,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdvisoryDetailScreen(advisory: a),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SectionHeader('How to read SARC information'),
          const LevelLegend(),
          const SectionHeader('About the 2023 event'),
          const SarcCard(
            child: Text(
              'On 4 October 2023, a glacial lake outburst flood (GLOF) from '
              'South Lhonak Lake affected the Teesta River in Sikkim. SARC '
              'studies radar satellite observations of the downstream '
              'corridor. Whether this specific area was affected is still '
              'being studied with satellite data and independent evidence.',
              style: TextStyle(height: 1.45, color: SarcColors.textMuted),
            ),
          ),
          const DisclaimerFooter(),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [SarcColors.navy, Color(0xFF14488F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white70, size: 18),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  AppConst.aoiName,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'No official warning shown in SARC',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'SARC does not issue official warnings. Check the Advisories tab '
            'for team-reviewed information, and follow Sikkim SDMA and the '
            'district administration for official instructions.',
            style: TextStyle(color: Colors.white, height: 1.4, fontSize: 13.5),
          ),
          SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.satellite_alt, color: Colors.white70, size: 16),
              SizedBox(width: 6),
              Text(
                'Latest satellite data: sample (V1)',
                style: TextStyle(color: Colors.white70, fontSize: 12.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SarcCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: SarcColors.blue, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: SarcColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
