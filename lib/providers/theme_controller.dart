import 'dart:async';

import 'package:flutter/material.dart';

import '../services/settings_service.dart';

/// Holds the app-wide [ThemeMode] and persists it per user in Firestore
/// (`users/{uid}/settings/preferences`), so the dark-mode choice belongs to the
/// account and survives restarts / syncs across devices. Toggled from the
/// drawer's "Dark mode" switch. The singular `config/theme.dart` supplies the
/// actual themes.
class ThemeController extends ChangeNotifier {
  ThemeController({SettingsService? service})
    : _service = service ?? SettingsService();

  final SettingsService _service;
  StreamSubscription<bool>? _sub;
  String? _uid;
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  /// (Re)binds to a user's stored preference. Called by the proxy provider
  /// whenever the authenticated uid changes.
  void start(String? uid) {
    if (uid == _uid) return;
    _sub?.cancel();
    _uid = uid;
    if (uid == null) {
      _mode = ThemeMode.light;
      Future.microtask(notifyListeners);
      return;
    }
    _sub = _service.watchDarkMode(uid).listen((dark) {
      final next = dark ? ThemeMode.dark : ThemeMode.light;
      if (next == _mode) return;
      _mode = next;
      notifyListeners();
    });
  }

  void setDark(bool value) {
    final next = value ? ThemeMode.dark : ThemeMode.light;
    if (next == _mode) return;
    _mode = next; // apply immediately; the stream echo is a no-op.
    notifyListeners();
    final uid = _uid;
    if (uid != null) {
      _service.setDarkMode(uid, value);
    }
  }

  void toggle() => setDark(!isDark);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
