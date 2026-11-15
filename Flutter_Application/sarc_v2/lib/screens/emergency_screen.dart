import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';
import '../core/i18n.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  Future<void> _call(BuildContext context, String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    var ok = false;
    try {
      ok = await launchUrl(uri);
    } catch (_) {}
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Tr('${'Could not open the dialler. Number:'.tr} $number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Tr('Emergency contacts')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          SarcCard(
            color: SarcColors.dangerBg,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: SarcColors.official),
                SizedBox(width: 10),
                Expanded(
                  child: Tr(
                    'In immediate danger, call 112. SARC cannot send help.',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final c in AppData.contacts) ...[
            _ContactCard(contact: c, onCall: _call),
            const SizedBox(height: 10),
          ],
          const DisclaimerFooter(),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final EmergencyContact contact;
  final Future<void> Function(BuildContext, String) onCall;

  const _ContactCard({required this.contact, required this.onCall});

  @override
  Widget build(BuildContext context) {
    final number = contact.number;
    return SarcCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tr(
                  contact.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                    color: SarcColors.navy,
                  ),
                ),
                const SizedBox(height: 3),
                Tr(
                  contact.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: SarcColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  fluttnumber!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: SarcColors.blue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => onCall(context, number),
            icon: const Icon(Icons.call, size: 18),
            label: const Tr('Call'),
          ),
        ],
      ),
    );
  }
}
