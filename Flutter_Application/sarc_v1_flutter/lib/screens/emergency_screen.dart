import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

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
        SnackBar(content: Text('Could not open the dialler. Number: $number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency contacts')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const SarcCard(
            color: Color(0xFFFDECEC),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded, color: SarcColors.official),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'In immediate danger, call 112. SARC cannot send help.',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final c in MockData.contacts) ...[
            _ContactCard(contact: c, onCall: _call),
            const SizedBox(height: 10),
          ],
          const SarcCard(
            child: Text(
              'Team note: confirm every number with the local authority '
              'before release, and fill in the blank entries. Numbers marked '
              '"confirm locally" are commonly published national numbers.',
              style: TextStyle(fontSize: 12.5, color: SarcColors.textMuted),
            ),
          ),
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
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                    color: SarcColors.navy,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  contact.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: SarcColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  number ?? 'Number to be added',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: number == null
                        ? SarcColors.textMuted
                        : SarcColors.blue,
                  ),
                ),
                if (contact.needsLocalConfirmation)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Confirm locally',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: SarcColors.interpreted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: number == null ? null : () => onCall(context, number),
            icon: const Icon(Icons.call, size: 18),
            label: const Text('Call'),
          ),
        ],
      ),
    );
  }
}
