import 'package:cloud_firestore/cloud_firestore.dart';

import 'database_service.dart';

/// Persists per-user app settings in Firestore at
/// `users/{uid}/settings/preferences`, so preferences such as dark mode are
/// stored against the account and stay in sync across devices.
class SettingsService {
  SettingsService({DatabaseService? database})
    : _db = database ?? DatabaseService();

  final DatabaseService _db;

  /// Emits the stored dark-mode flag (defaults to `false` when unset).
  Stream<bool> watchDarkMode(String uid) {
    return _db.settingsRef(uid).snapshots().map(
      (snap) => snap.data()?['darkMode'] == true,
    );
  }

  Future<void> setDarkMode(String uid, bool value) {
    return _db
        .settingsRef(uid)
        .set({'darkMode': value}, SetOptions(merge: true));
  }
}
