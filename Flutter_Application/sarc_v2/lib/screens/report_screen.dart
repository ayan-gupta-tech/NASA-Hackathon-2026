import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../utils/format.dart';
import '../widgets/common_widgets.dart';

/// Lets residents describe what they see. The report is saved on this
/// device (ReportStore). To send reports to the monitoring team, connect
/// ReportStore.add to the backend.
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

  static const _types = [
    'River level change',
    'Muddy or debris-filled water',
    'Riverbank erosion or damage',
    'Landslide near the river',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    reportStore.load();
  }

  @override
  void dispose() {
    _description.dispose();
    _place.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final p = profileStore.profile;
    await reportStore.add(
      ReportEntry(
        type: _type,
        place: _place.text.trim(),
        description: _description.text.trim(),
        time: DateTime.now(),
        reporter: p == null ? '' : '${p.name} (+91 ${p.mobile})',
        area: p == null ? '' : '${p.district}, ${p.state}',
      ),
    );
    if (!mounted) return;
    _description.clear();
    _place.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Tr('Report saved on this device.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Tr('Report an observation')),
      body: ListenableBuilder(
        listenable: reportStore,
        builder: (context, _) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              SarcCard(
                color: SarcColors.noticeBg,
                child: const Tr(
                  'Reports are community observations that help the '
                  'monitoring team check satellite indicators. They are not '
                  'verified and are not warnings. This form is NOT for '
                  'emergencies: in danger, call 112.',
                  style: TextStyle(height: 1.45),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _type,
                isExpanded: true,
                decoration: InputDecoration(labelText: 'What did you see?'.tr),
                items: [
                  for (final t in _types)
                    DropdownMenuItem(value: t, child: Tr(t)),
                ],
                onChanged: (v) => setState(() => _type = v ?? _type),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _place,
                decoration: InputDecoration(
                  labelText: 'Where? (village / landmark)'.tr,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter a place'.tr
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _description,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Describe what you saw'.tr,
                  alignLabelWithHint: true,
                ),
                validator: (v) => (v == null || v.trim().length < 10)
                    ? 'Please add a few more details'.tr
                    : null,
              ),
              const SizedBox(height: 8),
              Tr(
                'Your name, number, district and state from your profile are '
                'saved with the report.',
                style: TextStyle(fontSize: 12.5, color: SarcColors.textMuted),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submit,
                child: const Tr('Save report'),
              ),
              if (reportStore.items.isNotEmpty) ...[
                const SectionHeader('Your saved reports'),
                for (final r in reportStore.items) ...[
                  SarcCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Tr(
                                r.type,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: SarcColors.navy,
                                ),
                              ),
                            ),
                            Text(
                              formatDate(r.time),
                              style: TextStyle(
                                fontSize: 12,
                                color: SarcColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.place,
                          style: TextStyle(
                            fontSize: 13,
                            color: SarcColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(r.description),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ],
              const DisclaimerFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
