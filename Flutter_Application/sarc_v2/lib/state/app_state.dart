import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/i18n.dart';
import '../core/theme.dart';
import '../data/app_data.dart';
import '../models/models.dart';

/// Marks every widget on screen as dirty so it rebuilds. Needed because the
/// theme colours (SarcColors) and translations are read from static values,
/// so widgets must be told to redraw when the theme or language changes.
void rebuildAllElements() {
  final root = WidgetsBinding.instance.rootElement;
  if (root == null) return;
  void visit(Element e) {
    e.markNeedsBuild();
    e.visitChildren(visit);
  }

  root.visitChildren(visit);
}

/// User settings. Theme and language are saved with shared_preferences.
class AppSettings extends ChangeNotifier with WidgetsBindingObserver {
  static const _kTheme = 'themeMode';
  static const _kLang = 'language';
  static const languages = ['English', 'Hindi', 'Nepali'];

  double _textScale = 1.0;
  bool _notificationsEnabled = true;
  bool _officialOnly = false;
  String _language = 'English';
  ThemeMode _themeMode = ThemeMode.system;

  double get textScale => _textScale;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get officialOnly => _officialOnly;
  String get language => _language;
  ThemeMode get themeMode => _themeMode;

  bool get isDark => switch (_themeMode) {
        ThemeMode.dark => true,
        ThemeMode.light => false,
        ThemeMode.system =>
          WidgetsBinding.instance.platformDispatcher.platformBrightness ==
              Brightness.dark,
      };

  Locale get locale => switch (_language) {
        'Hindi' => const Locale('hi'),
        'Nepali' => const Locale('ne'),
        _ => const Locale('en'),
      };

  /// Call once from main() before runApp.
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final t = prefs.getString(_kTheme);
      _themeMode = ThemeMode.values.firstWhere(
        (m) => m.name == t,
        orElse: () => ThemeMode.system,
      );
      final l = prefs.getString(_kLang);
      if (l != null && languages.contains(l)) _language = l;
    } catch (_) {}
    _apply();
    WidgetsBinding.instance.addObserver(this);
  }

  void _apply() {
    SarcColors.dark = isDark;
    I18n.lang = _language;
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kTheme, _themeMode.name);
      await prefs.setString(_kLang, _language);
    } catch (_) {}
  }

  void _themeOrLangChanged() {
    _apply();
    rebuildAllElements();
    notifyListeners();
    _save();
  }

  @override
  void didChangePlatformBrightness() {
    if (_themeMode == ThemeMode.system) {
      _apply();
      rebuildAllElements();
      notifyListeners();
    }
  }

  set themeMode(ThemeMode v) {
    _themeMode = v;
    _themeOrLangChanged();
  }

  set language(String v) {
    _language = v;
    _themeOrLangChanged();
  }

  set textScale(double v) {
    _textScale = v;
    notifyListeners();
  }

  set notificationsEnabled(bool v) {
    _notificationsEnabled = v;
    notifyListeners();
  }

  set officialOnly(bool v) {
    _officialOnly = v;
    notifyListeners();
  }
}

final appSettings = AppSettings();

/// Notification history. Fill from the backend when it is connected.
class NotificationStore extends ChangeNotifier {
  final List<AppNotification> items = AppData.notifications();

  int get unread => items.where((n) => !n.read).length;

  void markRead(String id) {
    for (final n in items) {
      if (n.id == id && !n.read) {
        n.read = true;
        notifyListeners();
        return;
      }
    }
  }

  void markAllRead() {
    for (final n in items) {
      n.read = true;
    }
    notifyListeners();
  }
}

final notificationStore = NotificationStore();

/// The signed-in person. Stored on this device only (shared_preferences).
class ProfileStore extends ChangeNotifier {
  UserProfile? _profile;
  UserProfile? get profile => _profile;
  bool get hasProfile => _profile != null;

  static const _keys = [
    'profile_name',
    'profile_mobile',
    'profile_state',
    'profile_district',
  ];

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final name = p.getString('profile_name');
      final mobile = p.getString('profile_mobile');
      final state = p.getString('profile_state');
      final district = p.getString('profile_district');
      if (name != null && mobile != null && state != null && district != null) {
        _profile = UserProfile(
          name: name,
          mobile: mobile,
          state: state,
          district: district,
        );
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> save(UserProfile profile) async {
    _profile = profile;
    try {
      final p = await SharedPreferences.getInstance();
      await p.setString('profile_name', profile.name);
      await p.setString('profile_mobile', profile.mobile);
      await p.setString('profile_state', profile.state);
      await p.setString('profile_district', profile.district);
    } catch (_) {}
    notifyListeners();
  }

  Future<void> clear() async {
    _profile = null;
    try {
      final p = await SharedPreferences.getInstance();
      for (final k in _keys) {
        await p.remove(k);
      }
    } catch (_) {}
    notifyListeners();
  }
}

final profileStore = ProfileStore();

/// Observations saved from the Report screen, kept on this device.
/// Connect [ReportStore.add] to the backend to send them to the team.
class ReportStore extends ChangeNotifier {
  final List<ReportEntry> items = [];

  Future<void> load() async {
    try {
      final p = await SharedPreferences.getInstance();
      final raw = p.getStringList('reports') ?? [];
      items
        ..clear()
        ..addAll(
          raw.map(
            (s) => ReportEntry.fromJson(jsonDecode(s) as Map<String, dynamic>),
          ),
        );
    } catch (_) {}
    notifyListeners();
  }

  Future<void> add(ReportEntry entry) async {
    items.insert(0, entry);
    try {
      final p = await SharedPreferences.getInstance();
      await p.setStringList(
        'reports',
        items.map((e) => jsonEncode(e.toJson())).toList(),
      );
    } catch (_) {}
    notifyListeners();
  }
}

final reportStore = ReportStore();
