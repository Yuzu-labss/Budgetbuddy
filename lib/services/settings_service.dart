import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/theme.dart';
import 'database_service.dart';

/// Persists per-user app settings in Firestore at
/// `users/{uid}/settings/preferences`, so preferences such as the selected
/// theme are stored against the account and stay in sync across devices.
class SettingsService {
  SettingsService({DatabaseService? database})
    : _db = database ?? DatabaseService();

  final DatabaseService _db;

  /// Emits the stored theme kind. Falls back to the legacy `darkMode` flag for
  /// accounts saved before multi-theme support (dark -> midnight, else clean
  /// white), and to [ThemeKind.cleanWhite] when nothing is set.
  Stream<ThemeKind> watchTheme(String uid) {
    return _db.settingsRef(uid).snapshots().map((snap) {
      final data = snap.data();
      final stored = data?['theme'];
      if (stored is String && stored.isNotEmpty) {
        return ThemeKindX.fromName(stored);
      }
      // Legacy migration: honour the old boolean dark-mode preference.
      return data?['darkMode'] == true
          ? ThemeKind.midnight
          : ThemeKind.cleanWhite;
    });
  }

  Future<void> setTheme(String uid, ThemeKind kind) {
    return _db
        .settingsRef(uid)
        .set({'theme': kind.name}, SetOptions(merge: true));
  }
}
