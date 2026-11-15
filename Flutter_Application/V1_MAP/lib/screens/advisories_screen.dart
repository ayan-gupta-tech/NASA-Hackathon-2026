import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'advisory_detail_screen.dart';

class AdvisoriesScreen extends StatefulWidget {
  const AdvisoriesScreen({super.key});

  @override
  State<AdvisoriesScreen> createState() => _AdvisoriesScreenState();
}

class _AdvisoriesScreenState extends State<AdvisoriesScreen> {
  InfoLevel? _filter; // null = All

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appSettings,
      builder: (context, _) {
        var items = MockData.advisories.where(
          (a) => _filter == null || a.level == _filter,
        );
        if (appSettings.officialOnly) {
          items = items.where(
            (a) =>
                a.level == InfoLevel.verifiedHazard ||
                a.level == InfoLevel.officialWarning,
          );
        }
        final list = items.toList();

        return Scaffold(
          appBar: AppBar(title: const Text('Advisories')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const DemoBanner(),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: _filter == null,
                        onSelected: (_) => setState(() => _filter = null),
                      ),
                    ),
                    for (final level in InfoLevel.values)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          avatar: Icon(level.icon, size: 16, color: level.color),
                          label: Text(level.shortLabel),
                          selected: _filter == level,
                          onSelected: (_) => setState(() => _filter = level),
                        ),
                      ),
                  ],
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Only verified and official'),
                subtitle: const Text('Hide unverified satellite indicators'),
                value: appSettings.officialOnly,
                onChanged: (v) => appSettings.officialOnly = v,
              ),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('No advisories match this filter.')),
                ),
              for (final a in list) ...[
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
              const DisclaimerFooter(),
            ],
          ),
        );
      },
    );
  }
}
