import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../core/theme.dart';

/// The five information levels from the SARC brief. Every piece of
/// information in the app is tagged with exactly one of these so a
/// satellite signal is never mistaken for an official warning.
enum InfoLevel {
  satelliteObserved,
  derivedIndicator,
  interpretedExposure,
  verifiedHazard,
  officialWarning,
}

extension InfoLevelX on InfoLevel {
  String get label => switch (this) {
        InfoLevel.satelliteObserved => 'Satellite-observed change',
        InfoLevel.derivedIndicator => 'Algorithm-derived indicator',
        InfoLevel.interpretedExposure => 'Interpreted potential exposure',
        InfoLevel.verifiedHazard => 'Independently verified hazard',
        InfoLevel.officialWarning => 'Official warning',
      };

  String get shortLabel => switch (this) {
        InfoLevel.satelliteObserved => 'Satellite observed',
        InfoLevel.derivedIndicator => 'Derived indicator',
        InfoLevel.interpretedExposure => 'Potential exposure',
        InfoLevel.verifiedHazard => 'Verified',
        InfoLevel.officialWarning => 'Official warning',
      };

  String get description => switch (this) {
        InfoLevel.satelliteObserved =>
          'A change seen directly in satellite imagery. It is not a confirmed '
              'flood or damage report.',
        InfoLevel.derivedIndicator =>
          'A value calculated by an algorithm from satellite data. It can '
              'contain errors and has not been checked on the ground.',
        InfoLevel.interpretedExposure =>
          'The team\'s reading of which areas could be exposed. It is not a '
              'prediction.',
        InfoLevel.verifiedHazard =>
          'Checked against independent evidence such as field reports, '
              'gauges or authorities, and reviewed by the team.',
        InfoLevel.officialWarning =>
          'Issued by an authorized disaster-management authority. Always '
              'follow these first.',
      };

  Color get color => switch (this) {
        InfoLevel.satelliteObserved => SarcColors.satellite,
        InfoLevel.derivedIndicator => SarcColors.derived,
        InfoLevel.interpretedExposure => SarcColors.interpreted,
        InfoLevel.verifiedHazard => SarcColors.verified,
        InfoLevel.officialWarning => SarcColors.official,
      };

  IconData get icon => switch (this) {
        InfoLevel.satelliteObserved => Icons.satellite_alt,
        InfoLevel.derivedIndicator => Icons.analytics_outlined,
        InfoLevel.interpretedExposure => Icons.travel_explore,
        InfoLevel.verifiedHazard => Icons.verified_outlined,
        InfoLevel.officialWarning => Icons.campaign_outlined,
      };
}

class VerificationStep {
  final String label;
  final bool done;
  const VerificationStep(this.label, this.done);
}

class Advisory {
  final String id;
  final String title;
  final String summary;
  final String body;
  final String source;
  final String area;
  final InfoLevel level;
  final DateTime issuedAt;
  final List<String> actions;
  final List<VerificationStep> steps;
  final bool isSample;

  const Advisory({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.source,
    required this.area,
    required this.level,
    required this.issuedAt,
    required this.actions,
    required this.steps,
    this.isSample = true,
  });
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime time;
  final InfoLevel level;
  final String? advisoryId;
  bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.level,
    this.advisoryId,
    this.read = false,
  });
}

class EmergencyContact {
  final String name;
  final String description;
  final String? number; // null = number still to be added
  final String category;
  final bool needsLocalConfirmation;

  const EmergencyContact({
    required this.name,
    required this.description,
    required this.number,
    required this.category,
    this.needsLocalConfirmation = false,
  });
}

enum ExposureLevel { lower, moderate, higher }

extension ExposureLevelX on ExposureLevel {
  String get label => switch (this) {
        ExposureLevel.lower => 'Lower',
        ExposureLevel.moderate => 'Moderate',
        ExposureLevel.higher => 'Higher',
      };

  Color get color => switch (this) {
        ExposureLevel.lower => SarcColors.verified,
        ExposureLevel.moderate => SarcColors.interpreted,
        ExposureLevel.higher => SarcColors.official,
      };
}

class Settlement {
  final String name;
  final LatLng position;
  final ExposureLevel exposure;
  final String note;

  const Settlement({
    required this.name,
    required this.position,
    required this.exposure,
    required this.note,
  });
}

class Acquisition {
  final String sensor;
  final String band;
  final String date;
  final String details;
  final String status;
  final String purpose;

  const Acquisition({
    required this.sensor,
    required this.band,
    required this.date,
    required this.details,
    required this.status,
    required this.purpose,
  });
}

class SafetySection {
  final String title;
  final IconData icon;
  final List<String> points;
  const SafetySection(this.title, this.icon, this.points);
}
