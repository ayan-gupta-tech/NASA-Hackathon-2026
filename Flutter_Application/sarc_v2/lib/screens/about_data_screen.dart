import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/theme.dart';
import '../widgets/common_widgets.dart';
import '../core/i18n.dart';

class AboutDataScreen extends StatelessWidget {
  const AboutDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Tr('About and data')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Center(
            child: Image.asset(
              AppConst.logoFull,
              width: 200,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),
          const SarcCard(
            child: Tr(
              'SARC is a research-driven, multi-sensor SAR and geospatial '
              'platform. It studies satellite-observed changes, analyses '
              'river-corridor and settlement exposure, and shares '
              'human-reviewed information with communities.',
              style: TextStyle(height: 1.5),
            ),
          ),
          const SectionHeader('Study area'),
          SarcCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tr(
                  AppConst.aoiName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: SarcColors.navy,
                  ),
                ),
                SizedBox(height: 6),
                Tr(
                  'North 27.2025, South 27.1575\n'
                  'West 88.4897, East 88.5403\n'
                  'WGS84 (EPSG:4326), about 5 km x 5 km, along the Teesta river '
                  'in Sikkim.',
                ),
              ],
            ),
          ),
          const SectionHeader('Satellite data'),
          SarcCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Source(
                  'Sentinel-1 (C-band SAR)',
                  'Historical before-and-after observations of the October '
                      '2023 glacial lake outburst flood. Radar sees through '
                      'cloud and darkness.',
                ),
                const Divider(height: 24),
                const _Source(
                  'NISAR (S-band SAR)',
                  'Later observations of the same region, used to study how '
                      'S-band radar can support river monitoring.',
                ),
                const Divider(height: 24),
                const _Source(
                  'Data access',
                  'Satellite products are obtained through ISRO Bhoonidhi '
                      'and processed with ESA SNAP and Python.',
                ),
              ],
            ),
          ),
          const SectionHeader('How information reaches you'),
          const SarcCard(
            child: _Bullets([
              'Satellite observations are processed and analysed.',
              'The monitoring team reviews the results.',
              'Results are checked against independent evidence.',
              'Only reviewed advisories are published in the app.',
              'Official warnings come from the authorized authorities, never '
                  'from SARC.',
            ]),
          ),
          const SectionHeader('Limitations'),
          const SarcCard(
            child: _Bullets([
              'SARC does not provide validated flood prediction.',
              'A satellite change indicator is not a confirmed flood or damage report.',
              'NISAR data from 2026 are later observations. They are not '
                  'imagery of the 2023 event.',
              'Sentinel-1 (C-band) and NISAR (S-band) values are not '
                  'interchangeable and are not compared directly.',
              'Satellite pixel spacing is not the same as effective '
                  'spatial resolution.',
              'SARC complements official channels. It does not replace them.',
            ]),
          ),
          const SectionHeader('Information levels'),
          const LevelLegend(),
          const SectionHeader('Team'),
          const SarcCard(
            child: _Bullets([
              'Ayan: mobile app development',
              'Shrujal: analysis and outputs in Google Colab',
              'Alfaz: dataset refinement in ESA SNAP',
            ]),
          ),
          const SizedBox(height: 8),
          Center(
            child: Tr(
              AppConst.versionLabel,
              style: TextStyle(fontSize: 12, color: SarcColors.textMuted),
            ),
          ),
          const DisclaimerFooter(),
        ],
      ),
    );
  }
}

class _Source extends StatelessWidget {
  final String title;
  final String text;
  const _Source(this.title, this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tr(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: SarcColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Tr(text, style: const TextStyle(height: 1.4)),
      ],
    );
  }
}

class _Bullets extends StatelessWidget {
  final List<String> items;
  const _Bullets(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final t in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 7, right: 10),
                  child: Icon(Icons.circle, size: 6, color: SarcColors.blue),
                ),
                Expanded(child: Tr(t, style: const TextStyle(height: 1.4))),
              ],
            ),
          ),
      ],
    );
  }
}
