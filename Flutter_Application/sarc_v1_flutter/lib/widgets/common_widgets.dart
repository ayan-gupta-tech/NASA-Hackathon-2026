import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../utils/format.dart';

/// White rounded card used across the app.
class SarcCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;

  const SarcCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? SarcColors.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: SarcColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader(this.title, {super.key, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: SarcColors.navy,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      ),
    );
  }
}

/// Small coloured pill showing which of the five information levels
/// something belongs to.
class LevelBadge extends StatelessWidget {
  final InfoLevel level;
  const LevelBadge(this.level, {super.key});

  @override
  Widget build(BuildContext context) {
    final c = level.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(level.icon, size: 14, color: c),
          const SizedBox(width: 4),
          Text(
            level.shortLabel,
            style:
                TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Orange strip reminding everyone that V1 content is sample content.
class DemoBanner extends StatelessWidget {
  const DemoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4DC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0C36A)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.science_outlined, size: 20, color: Color(0xFF8A5A00)),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              AppConst.sampleDataNotice,
              style: TextStyle(fontSize: 12.5, color: Color(0xFF6B4500)),
            ),
          ),
        ],
      ),
    );
  }
}

/// Footer reminding users that SARC does not replace official channels.
class DisclaimerFooter extends StatelessWidget {
  const DisclaimerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: SarcColors.textMuted),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              AppConst.disclaimerShort,
              style: TextStyle(fontSize: 12.5, color: SarcColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}

/// Explains all five information levels. Used on Home and in About.
class LevelLegend extends StatelessWidget {
  const LevelLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return SarcCard(
      child: Column(
        children: [
          for (final level in InfoLevel.values) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(level.icon, color: level.color, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        level.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: level.color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        level.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: SarcColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (level != InfoLevel.values.last) const Divider(height: 22),
          ],
        ],
      ),
    );
  }
}

/// List card for one advisory. Used on Home and the Advisories screen.
class AdvisoryCard extends StatelessWidget {
  final Advisory advisory;
  final VoidCallback onTap;

  const AdvisoryCard({super.key, required this.advisory, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SarcCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              LevelBadge(advisory.level),
              const SizedBox(width: 8),
              if (advisory.isSample)
                const Text(
                  'SAMPLE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF8A5A00),
                  ),
                ),
              const Spacer(),
              Text(
                timeAgo(advisory.issuedAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: SarcColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            advisory.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: SarcColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            advisory.summary,
            style: const TextStyle(fontSize: 13.5, color: SarcColors.textMuted),
          ),
        ],
      ),
    );
  }
}
