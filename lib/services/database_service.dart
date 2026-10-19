import 'package:cloud_firestore/cloud_firestore.dart';

import '../config/constants.dart';

/// Thin wrapper around the Firestore references used by the app.
class DatabaseService {
  DatabaseService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> userRef(String uid) =>
      _db.collection(kUsersCollection).doc(uid);

  CollectionReference<Map<String, dynamic>> budgetsRef(String uid) =>
      userRef(uid).collection(kBudgetsCollection);

  CollectionReference<Map<String, dynamic>> expensesRef(String uid) =>
      userRef(uid).collection(kExpensesCollection);

  /// Single per-user settings document (`users/{uid}/settings/preferences`).
  DocumentReference<Map<String, dynamic>> settingsRef(String uid) =>
      userRef(uid).collection(kSettingsCollection).doc(kSettingsDocId);
}
