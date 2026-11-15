import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../widgets/common_widgets.dart';

/// Lets residents describe what they see. V1 = UI only (nothing is sent).
/// V2: send to Firebase so the monitoring team can review it.
class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _place = TextEditingController();
  String _type = 'River level change';
  bool _shareLocation = false;

  static const _types = [
    'River level change',
    'Muddy or debris-filled water',
    'Riverbank erosion or damage',
    'Landslide near the river',
    'Other',
  ];

  @override
  void dispose() {
    _description.dispose();
    _place.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Thank you'),
        content: const Text(
          'V1 demo: your report was not sent anywhere. In V2, reports will '
          'go to the SARC monitoring team as UNVERIFIED community '
          'observations and will not be shown to others as warnings.\n\n'
          'If someone is in danger, call 112 now.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report an observation')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const SarcCard(
              color: Color(0xFFFFF4DC),
              child: Text(
                'Reports are unverified community observations that help the '
                'monitoring team check satellite indicators. This form is NOT '
                'for emergencies. In danger, call 112.',
                style: TextStyle(height: 1.45),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _type,
              decoration: const InputDecoration(labelText: 'What did you see?'),
              items: [
                for (final t in _types) DropdownMenuItem(value: t, child: Text(t)),
              ],
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _place,
              decoration: const InputDecoration(
                labelText: 'Where? (village / landmark)',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Please enter a place' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _description,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Describe what you saw',
                alignLabelWithHint: true,
              ),
              validator: (v) => (v == null || v.trim().length < 10)
                  ? 'Please add a few more details'
                  : null,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Attach my approximate location'),
              subtitle: const Text(
                'Off by default. Only shared if you turn this on (used in V2).',
                style: TextStyle(color: SarcColors.textMuted),
              ),
              value: _shareLocation,
              onChanged: (v) => setState(() => _shareLocation = v),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Photo upload arrives in V2.')),
              ),
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Add photo (V2)'),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: _submit, child: const Text('Submit report')),
            const DisclaimerFooter(),
          ],
        ),
      ),
    );
  }
}
