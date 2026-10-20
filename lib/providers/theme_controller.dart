import 'dart:async';

import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../services/settings_service.dart';

/// Holds the app-wide selected [ThemeKind] and persists it per user in Firestore
/// (`users/{uid}/settings/preferences`), so the theme choice belongs to the
/// account and survives restarts / syncs across devices. Selected from the
/// drawer's theme picker. The singular `config/theme.dart` supplies the actual
/// themes.
class ThemeController extends ChangeNotifier {
  ThemeController({SettingsService? service})
    : _service = service ?? SettingsService();

  final SettingsService _service;
  StreamSubscription<ThemeKind>? _sub;
  String? _uid;
  ThemeKind _kind = ThemeKind.cleanWhite;

  /// The currently selected theme.
  ThemeKind get kind => _kind;

  /// Convenience for widgets that still reason in terms of brightness.
  bool get isDark => _kind.isDark;

  /// (Re)binds to a user's stored preference. Called by the proxy provider
  /// whenever the authenticated uid changes.
  void start(String? uid) {
    if (uid == _uid) return;
    _sub?.cancel();
    _uid = uid;
    if (uid == null) {
      _kind = ThemeKind.cleanWhite;
      Future.microtask(notifyListeners);
      return;
    }
    _sub = _service.watchTheme(uid).listen((next) {
      if (next == _kind) return;
      _kind = next;
      notifyListeners();
    });
  }

  /// Selects [kind], applying it immediately and persisting it for the account.
  void setKind(ThemeKind kind) {
    if (kind == _kind) return;
    _kind = kind; // apply immediately; the stream echo is a no-op.
    notifyListeners();
    final uid = _uid;
    if (uid != null) {
      _service.setTheme(uid, kind);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
