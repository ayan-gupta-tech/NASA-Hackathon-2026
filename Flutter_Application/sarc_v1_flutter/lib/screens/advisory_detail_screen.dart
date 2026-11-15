import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/models.dart';
import '../utils/format.dart';
import '../widgets/common_widgets.dart';

class AdvisoryDetailScreen extends StatelessWidget {
  final Advisory advisory;
  const AdvisoryDetailScreen({super.key, required this.advisory});

  @override
  Widget build(BuildContext context) {
    final a = advisory;
    return Scaffold(
      appBar: AppBar(title: const Text('Advisory')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Row(
            children: [
              LevelBadge(a.level),
              const SizedBox(width: 8),
              if (a.isSample)
                const Text(
                  'SAMPLE',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8A5A00),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            a.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: SarcColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${formatDateTime(a.issuedAt)}  -  ${a.area}',
            style: const TextStyle(fontSize: 12.5, color: SarcColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            'Source: ${a.source}',
            style: const TextStyle(fontSize: 12.5, color: SarcColors.textMuted),
          ),
          const SectionHeader('What this means'),
          SarcCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.body, style: const TextStyle(height: 1.5)),
                const Divider(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(a.level.icon, color: a.level.color, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        a.level.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: SarcColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SectionHeader('What you can do'),
          SarcCard(
            child: Column(
              children: [
                for (final action in a.actions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          size: 20,
                          color: SarcColors.blue,
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: Text(action)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SectionHeader('How this was checked'),
          SarcCard(
            child: Column(
              children: [
                for (final step in a.steps)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Icon(
                          step.done
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: step.done
                              ? SarcColors.verified
                              : SarcColors.textMuted,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            step.label,
                            style: TextStyle(
                              color: step.done ? null : SarcColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const DisclaimerFooter(),
        ],
      ),
    );
  }
}
