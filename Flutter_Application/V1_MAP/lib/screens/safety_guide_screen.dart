import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/mock_data.dart';
import '../widgets/common_widgets.dart';

class SafetyGuideScreen extends StatefulWidget {
  const SafetyGuideScreen({super.key});

  @override
  State<SafetyGuideScreen> createState() => _SafetyGuideScreenState();
}

class _SafetyGuideScreenState extends State<SafetyGuideScreen> {
  late final List<bool> _kitChecked =
      List<bool>.filled(MockData.emergencyKit.length, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety guide')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const SarcCard(
            color: Color(0xFFEAF3FC),
            child: Text(
              'General river-safety guidance. It is not specific to any '
              'satellite result. Local authorities may give different '
              'instructions, and theirs always come first.',
              style: TextStyle(height: 1.45),
            ),
          ),
          const SizedBox(height: 12),
          for (final s in MockData.safetySections) ...[
            SarcCard(
              padding: EdgeInsets.zero,
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(s.icon, color: SarcColors.blue),
                  title: Text(
                    s.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: SarcColors.navy,
                    ),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final p in s.points)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6, right: 10),
                              child: Icon(Icons.circle,
                                  size: 6, color: SarcColors.blue),
                            ),
                            Expanded(child: Text(p)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          const SectionHeader('Emergency kit checklist'),
          SarcCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (var i = 0; i < MockData.emergencyKit.length; i++)
                  CheckboxListTile(
                    dense: true,
                    value: _kitChecked[i],
                    onChanged: (v) => setState(() => _kitChecked[i] = v ?? false),
                    title: Text(MockData.emergencyKit[i]),
                    controlAffinity: ListTileControlAffinity.leading,
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
