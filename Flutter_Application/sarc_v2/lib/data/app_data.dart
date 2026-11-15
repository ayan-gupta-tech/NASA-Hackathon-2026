import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/models.dart';

/// Content shown by the app.
///
/// [advisories] and [notifications] start EMPTY: SARC only shows an advisory
/// after the monitoring team has reviewed and published it. When the backend
/// (Firebase) is connected, fill these lists from it - the screens already
/// handle both the empty and the filled case.
class AppData {
  // ----------------------------------------------------------------- MAP
  static const double aoiCenterLat = (AppConst.aoiNorth + AppConst.aoiSouth) / 2;
  static const double aoiCenterLng = (AppConst.aoiWest + AppConst.aoiEast) / 2;

  // ---------------------------------------------------------- ADVISORIES
  static final List<Advisory> advisories = <Advisory>[];

  static Advisory? advisoryById(String? id) {
    if (id == null) return null;
    for (final a in advisories) {
      if (a.id == id) return a;
    }
    return null;
  }

  // ------------------------------------------------------- NOTIFICATIONS
  static List<AppNotification> notifications() => <AppNotification>[];

  // ------------------------------------------------------------ CONTACTS
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
    ),
    EmergencyContact(
      name: 'District Disaster Control Room',
      description: 'Toll-free district emergency operations centre.',
      number: '1077',
      category: 'Disaster management',
    ),
    EmergencyContact(
      name: 'Police',
      description: 'Police emergency line.',
      number: '100',
      category: 'Emergency',
    ),
    EmergencyContact(
      name: 'Fire Service',
      description: 'Fire and rescue.',
      number: '101',
      category: 'Emergency',
    ),
    EmergencyContact(
      name: 'Ambulance',
      description: 'Medical emergency.',
      number: '108',
      category: 'Emergency',
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
