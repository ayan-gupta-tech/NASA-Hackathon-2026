import 'package:flutter/foundation.dart';

import '../data/mock_data.dart';
import '../models/models.dart';

/// User settings. V2 can persist these with shared_preferences / Firebase.
class AppSettings extends ChangeNotifier {
  double _textScale = 1.0;
  bool _notificationsEnabled = true;
  bool _officialOnly = false;
  String _language = 'English';

  double get textScale => _textScale;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get officialOnly => _officialOnly;
  String get language => _language;

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

  set language(String v) {
    _language = v;
    notifyListeners();
  }
}

final appSettings = AppSettings();

/// Notification history. V2 replaces the mock list with Firebase messages.
class NotificationStore extends ChangeNotifier {
  final List<AppNotification> items = MockData.notifications();

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
