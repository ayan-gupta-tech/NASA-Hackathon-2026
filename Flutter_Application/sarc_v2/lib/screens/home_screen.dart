import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../data/app_data.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'advisory_detail_screen.dart';
import 'notifications_screen.dart';
import 'safety_guide_screen.dart';
import '../core/i18n.dart';

class HomeScreen extends StatelessWidget {
  /// Lets quick-action tiles switch the bottom-navigation tab.
  /// Tab indexes: 0 Home, 1 Map, 2 Advisories, 3 Emergency, 4 More.
  final ValueChanged<int> onGoToTab;

  const HomeScreen({super.key, required this.onGoToTab});

  @override
  Widget build(BuildContext context) {
    final latest = AppData.advisories.take(2).toList();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            padding: SarcColors.dark ? const EdgeInsets.all(3) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: SarcColors.dark ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              AppConst.logoSymbol,
              errorBuilder: (_, __, ___) =>
                  Icon(Icons.satellite_alt, color: SarcColors.navy),
            ),
          ),
        ),
        title: const Tr('SARC'),
        actions: [
          IconButton(
            tooltip: (SarcColors.dark ? 'Light mode' : 'Dark mode').tr,
            onPressed: () => appSettings.themeMode =
                SarcColors.dark ? ThemeMode.light : ThemeMode.dark,
            icon: Icon(
              SarcColors.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          ListenableBuilder(
            listenable: notificationStore,
            builder: (context, _) => IconButton(
              tooltip: 'Notifications'.tr,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
              icon: Badge(
                isLabelVisible: notificationStore.unread > 0,
                label: Tr('${notificationStore.unread}'),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          ListenableBuilder(
            listenable: profileStore,
            builder: (context, _) {
              final p = profileStore.profile;
              if (p == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 12, left: 2),
                child: Tr(
                  '${'Hello'.tr}, ${p.name}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: SarcColors.navy,
                  ),
                ),
              );
            },
          ),
          const _StatusCard(),
          const SectionHeader('Quick actions'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ActionTile(
                  icon: Icons.map_outlined,
                  label: 'View map',
                  color: SarcColors.blue,
                  onTap: () => onGoToTab(1),
                ),
              ),
              Expanded(
                child: _ActionTile(
                  icon: Icons.shield_outlined,
                  label: 'Safety guide',
                  color: SarcColors.verified,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const SafetyGuideScreen()),
                  ),
                ),
              ),
              Expanded(
                child: _ActionTile(
                  icon: Icons.phone_in_talk_outlined,
                  label: 'Emergency contacts',
                  color: SarcColors.official,
                  onTap: () => onGoToTab(3),
                ),
              ),
            ],
          ),
          SectionHeader(
            'Latest updates',
            actionLabel: 'See all',
            onAction: () => onGoToTab(2),
          ),
          if (latest.isEmpty)
            const SarcCard(
              child: EmptyState(
                icon: Icons.campaign_outlined,
                title: 'No advisories published',
                message: 'When the SARC team publishes an advisory for your '
                    'area, it will appear here.',
              ),
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
          SarcCard(
            child: Tr(
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
        gradient: LinearGradient(
          colors: [SarcColors.brandNavy, Color(0xFF14488F)],
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
                child: Tr(
                  AppConst.aoiName,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Tr(
            'Study area: Teesta river corridor',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8),
          Tr(
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
              Expanded(
                child: Tr(
                  'Monitoring with Sentinel-1 and NISAR radar satellites',
                  style: TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact quick-action button: round tinted icon with a short label below.
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.14),
                border: Border.all(color: color.withOpacity(0.35)),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Tr(
              label,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                height: 1.25,
                fontWeight: FontWeight.w600,
                color: SarcColors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
