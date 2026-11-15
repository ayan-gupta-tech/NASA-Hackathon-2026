import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../utils/format.dart';
import '../core/i18n.dart';
import '../state/app_state.dart';

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
            child: Tr(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: SarcColors.navy,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(onPressed: onAction, child: Tr(actionLabel!)),
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
          Tr(
            level.shortLabel,
            style:
                TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Friendly message shown when a list has nothing to show yet.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      child: Column(
        children: [
          Icon(icon, size: 44, color: SarcColors.textMuted),
          const SizedBox(height: 12),
          Tr(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: SarcColors.navy,
            ),
          ),
          const SizedBox(height: 6),
          Tr(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: SarcColors.textMuted,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: SarcColors.textMuted),
          SizedBox(width: 8),
          Expanded(
            child: Tr(
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
                      Tr(
                        level.label,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: level.color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Tr(
                        level.description,
                        style: TextStyle(
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
              const Spacer(),
              Tr(
                timeAgo(advisory.issuedAt),
                style: TextStyle(
                  fontSize: 12,
                  color: SarcColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Tr(
            advisory.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: SarcColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Tr(
            advisory.summary,
            style: TextStyle(fontSize: 13.5, color: SarcColors.textMuted),
          ),
        ],
      ),
    );
  }
}

/// English / Hindi / Nepali switch. Changes the whole app immediately and is
/// remembered for the next launch (see AppSettings.language).
class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  static const _labels = {
    'English': 'English',
    'Hindi': 'हिन्दी',
    'Nepali': 'नेपाली',
  };

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appSettings,
      builder: (context, _) => SizedBox(
        width: double.infinity,
        child: SegmentedButton<String>(
          showSelectedIcon: false,
          segments: [
            for (final e in _labels.entries)
              ButtonSegment<String>(value: e.key, label: Text(e.value)),
          ],
          selected: {appSettings.language},
          onSelectionChanged: (s) => appSettings.language = s.first,
        ),
      ),
    );
  }
}
