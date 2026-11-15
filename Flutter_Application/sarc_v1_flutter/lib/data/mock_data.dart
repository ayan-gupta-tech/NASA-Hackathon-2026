import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../core/constants.dart';
import '../models/models.dart';

/// ALL SAMPLE DATA LIVES HERE.
/// V2 replaces advisories/notifications with Firebase. V3 replaces the map
/// placeholders with real Sentinel-1 / NISAR outputs from Colab + SNAP.
class MockData {
  // ---------------------------------------------------------------- MAP
  static final LatLng aoiCenter = LatLng(
    (AppConst.aoiNorth + AppConst.aoiSouth) / 2,
    (AppConst.aoiWest + AppConst.aoiEast) / 2,
  );

  static final List<LatLng> aoiPolygon = [
    LatLng(AppConst.aoiNorth, AppConst.aoiWest),
    LatLng(AppConst.aoiNorth, AppConst.aoiEast),
    LatLng(AppConst.aoiSouth, AppConst.aoiEast),
    LatLng(AppConst.aoiSouth, AppConst.aoiWest),
  ];

  /// ILLUSTRATIVE river line through the AOI (not the surveyed Teesta course).
  /// V3: replace with GeoJSON exported by the team.
  static final List<LatLng> riverLine = [
    LatLng(27.2025, 88.4960),
    LatLng(27.1950, 88.5000),
    LatLng(27.1880, 88.5050),
    LatLng(27.1800, 88.5120),
    LatLng(27.1720, 88.5200),
    LatLng(27.1650, 88.5280),
    LatLng(27.1575, 88.5350),
  ];

  /// Builds a band around [riverLine]. Used for the placeholder water layers.
  static List<LatLng> riverBand(double halfWidthDeg) {
    final left =
        riverLine.map((p) => LatLng(p.latitude, p.longitude - halfWidthDeg));
    final right = riverLine.reversed
        .map((p) => LatLng(p.latitude, p.longitude + halfWidthDeg));
    return [...left, ...right];
  }

  static List<LatLng> get preEventWater => riverBand(0.0009);
  static List<LatLng> get postEventWater => riverBand(0.0019);

  /// Two placeholder "change" patches along the river.
  static List<List<LatLng>> get changePatches => [
        [
          LatLng(27.1905, 88.5010),
          LatLng(27.1905, 88.5075),
          LatLng(27.1860, 88.5075),
          LatLng(27.1860, 88.5010),
        ],
        [
          LatLng(27.1700, 88.5200),
          LatLng(27.1700, 88.5270),
          LatLng(27.1655, 88.5270),
          LatLng(27.1655, 88.5200),
        ],
      ];

  /// Approximate positions only - verify with OpenStreetMap data in V3.
  static final List<Settlement> settlements = [
    Settlement(
      name: 'Singtam (north edge)',
      position: LatLng(27.1990, 88.4990),
      exposure: ExposureLevel.moderate,
      note: 'Sample entry. Exposure will be derived from distance to the river '
          'corridor and terrain height in V3.',
    ),
    Settlement(
      name: 'Majitar',
      position: LatLng(27.1815, 88.5110),
      exposure: ExposureLevel.higher,
      note: 'Sample entry. Close to the river corridor in this demo layer.',
    ),
    Settlement(
      name: 'Rangpo (south edge)',
      position: LatLng(27.1640, 88.5290),
      exposure: ExposureLevel.lower,
      note: 'Sample entry. Further from the river corridor in this demo layer.',
    ),
  ];

  // ---------------------------------------------------------- ADVISORIES
  static final List<Advisory> advisories = [
    Advisory(
      id: 'adv-3',
      title: 'Sample: official warning format',
      summary: 'Shows how an authority-issued warning will look in SARC.',
      body: 'This is a SAMPLE entry. Real official warnings will only appear '
          'here after they are issued by an authorized disaster-management '
          'authority and entered by the monitoring team. SARC never creates '
          'an official warning from satellite data.',
      source: 'Sample - authorized authority',
      area: AppConst.aoiName,
      level: InfoLevel.officialWarning,
      issuedAt: DateTime.now().subtract(const Duration(hours: 5)),
      actions: [
        'Follow the instructions given by the authority first.',
        'Keep your phone charged and listen to local announcements.',
        'Help neighbours who may need support.',
      ],
      steps: [
        VerificationStep('Satellite signal detected', true),
        VerificationStep('Reviewed by monitoring team', true),
        VerificationStep('Verified with independent evidence', true),
        VerificationStep('Issued by authorized authority', true),
      ],
    ),
    Advisory(
      id: 'adv-2',
      title: 'Sample: verified community advisory',
      summary: 'Shows a team-reviewed advisory with independent evidence.',
      body: 'This is a SAMPLE entry. A verified advisory means the monitoring '
          'team compared satellite indicators with independent evidence '
          '(for example field reports or river-level data) and reviewed it '
          'before publishing. It is still not an official warning.',
      source: 'Sample - SARC monitoring team',
      area: AppConst.aoiName,
      level: InfoLevel.verifiedHazard,
      issuedAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      actions: [
        'Stay away from the riverbank until the situation is clearer.',
        'Check the Emergency tab for local contacts.',
        'Share only verified information with others.',
      ],
      steps: [
        VerificationStep('Satellite signal detected', true),
        VerificationStep('Reviewed by monitoring team', true),
        VerificationStep('Verified with independent evidence', true),
        VerificationStep('Issued by authorized authority', false),
      ],
    ),
    Advisory(
      id: 'adv-1',
      title: 'Sample: satellite indicator near river corridor',
      summary: 'Shows how an unverified satellite signal will be labelled.',
      body: 'This is a SAMPLE entry. A satellite indicator means a change was '
          'seen in radar imagery (for example a different backscatter '
          'pattern near the river). It has NOT been confirmed as a flood or '
          'damage, and it has not been reviewed by an authority.',
      source: 'Sample - Sentinel-1 analysis',
      area: AppConst.aoiName,
      level: InfoLevel.satelliteObserved,
      issuedAt: DateTime.now().subtract(const Duration(days: 3)),
      actions: [
        'No action is required based on this entry alone.',
        'Read the Safety guide so you know what to do if conditions change.',
      ],
      steps: [
        VerificationStep('Satellite signal detected', true),
        VerificationStep('Reviewed by monitoring team', false),
        VerificationStep('Verified with independent evidence', false),
        VerificationStep('Issued by authorized authority', false),
      ],
    ),
  ];

  static Advisory? advisoryById(String? id) {
    if (id == null) return null;
    for (final a in advisories) {
      if (a.id == id) return a;
    }
    return null;
  }

  // ------------------------------------------------------- NOTIFICATIONS
  static List<AppNotification> notifications() => [
        AppNotification(
          id: 'n-3',
          title: 'Sample official warning format',
          body: 'Tap to see how an official warning will be shown.',
          time: DateTime.now().subtract(const Duration(hours: 5)),
          level: InfoLevel.officialWarning,
          advisoryId: 'adv-3',
        ),
        AppNotification(
          id: 'n-2',
          title: 'Sample verified advisory',
          body: 'A team-reviewed advisory for your area (sample).',
          time: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          level: InfoLevel.verifiedHazard,
          advisoryId: 'adv-2',
        ),
        AppNotification(
          id: 'n-1',
          title: 'New satellite data processed (sample)',
          body: 'A new Sentinel-1 scene was processed. No advisory attached.',
          time: DateTime.now().subtract(const Duration(days: 3)),
          level: InfoLevel.satelliteObserved,
          advisoryId: 'adv-1',
          read: true,
        ),
      ];

  // ------------------------------------------------------------ CONTACTS
  // Numbers marked needsLocalConfirmation must be confirmed with the local
  // authority before the app is released. Numbers set to null are blanks
  // for the team to fill in.
  static const List<EmergencyContact> contacts = [
    EmergencyContact(
      name: 'National Emergency Number',
      description: 'Single emergency number for police, fire and ambulance.',
      number: '112',
      category: 'Emergency',
    ),
    EmergencyContact(
      name: 'Disaster Management Helpline',
      description: 'National disaster management helpline.',
      number: '1078',
      category: 'Disaster management',
      needsLocalConfirmation: true,
    ),
    EmergencyContact(
      name: 'Police',
      description: 'Local police emergency line.',
      number: '100',
      category: 'Emergency',
      needsLocalConfirmation: true,
    ),
    EmergencyContact(
      name: 'Fire Service',
      description: 'Fire and rescue.',
      number: '101',
      category: 'Emergency',
      needsLocalConfirmation: true,
    ),
    EmergencyContact(
      name: 'Ambulance',
      description: 'Medical emergency. Services can vary by state.',
      number: '108',
      category: 'Emergency',
      needsLocalConfirmation: true,
    ),
    EmergencyContact(
      name: 'Sikkim State Disaster Management Authority',
      description: 'State disaster authority. Number to be added by the team.',
      number: null,
      category: 'Disaster management',
    ),
    EmergencyContact(
      name: 'East Sikkim District Control Room',
      description: 'District administration. Number to be added by the team.',
      number: null,
      category: 'Disaster management',
    ),
  ];

  // --------------------------------------------------------- ACQUISITIONS
  // Mirrors the project brief: these are CANDIDATES, not confirmed scenes.
  static const List<Acquisition> acquisitions = [
    Acquisition(
      sensor: 'Sentinel-1A',
      band: 'C-band',
      date: '28 Sep 2023 (priority candidate)',
      details: 'GRD, IW mode, VV + VH',
      status: 'Candidate - scene and AOI coverage not yet verified',
      purpose: 'Pre-event reference for the 4 Oct 2023 GLOF study',
    ),
    Acquisition(
      sensor: 'Sentinel-1A',
      band: 'C-band',
      date: '7 Oct 2023 (priority candidate)',
      details: 'GRD, IW mode, VV + VH',
      status: 'Candidate - scene and AOI coverage not yet verified',
      purpose: 'Post-event observation for the 4 Oct 2023 GLOF study',
    ),
    Acquisition(
      sensor: 'NISAR',
      band: 'S-band',
      date: '24 Aug, 5 Sep, 29 Sep 2026',
      details: 'GCOV, HH + HV, 10 m spacing, track 170, frame 15',
      status: 'Candidate - footprint overlap with AOI not yet verified',
      purpose: 'Later-condition and sensor-comparison study (not 2023 imagery)',
    ),
  ];

  // --------------------------------------------------------- SAFETY GUIDE
  static const List<SafetySection> safetySections = [
    SafetySection('Know the warning signs', Icons.visibility_outlined, [
      'A sudden rise or sudden drop in river level.',
      'Muddy, debris-filled water or a change in river sound.',
      'Official announcements from the authorities or local leaders.',
      'Satellite indicators in SARC are NOT warning signs on their own.',
    ]),
    SafetySection('Before: get ready', Icons.checklist_rtl, [
      'Learn the safest route to higher ground away from the river.',
      'Agree a meeting point with your family.',
      'Keep important documents in a waterproof bag.',
      'Save the emergency numbers from the Emergency tab.',
      'Keep a torch, radio, power bank and first-aid kit ready.',
    ]),
    SafetySection('During: stay safe', Icons.shield_outlined, [
      'Follow instructions from the authorities first.',
      'Move to higher ground, away from the riverbank.',
      'Do not walk or drive through flowing water.',
      'Help children, elderly people and neighbours who need support.',
    ]),
    SafetySection('After: recover safely', Icons.health_and_safety_outlined, [
      'Return home only when the authorities say it is safe.',
      'Stay away from damaged buildings, slopes and riverbanks.',
      'Do not drink flood water or use food that touched it.',
      'Report damage to the local authorities.',
    ]),
  ];

  static const List<String> emergencyKit = [
    'Drinking water and dry food',
    'Torch and spare batteries',
    'Radio and power bank',
    'First-aid kit and medicines',
    'Copies of ID and documents (waterproof bag)',
    'Warm clothes and a blanket',
  ];
}
