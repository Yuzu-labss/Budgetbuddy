import 'dart:async';

import '../models/expense.dart';
import 'database_service.dart';

/// Backs expenses with Firestore at `users/{uid}/expenses`, giving each
/// account its own private set of entries inside the shared Firebase project.
class ExpenseService {
  ExpenseService({DatabaseService? database})
    : _db = database ?? DatabaseService();

  final DatabaseService _db;

  Stream<List<Expense>> watchExpenses(String uid) {
    return _db.expensesRef(uid).snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Expense.fromMap(doc.data(), doc.id))
          .toList(),
    );
  }

  Future<void> add(String uid, Expense entry) async {
    final ref = _db.expensesRef(uid).doc();
    await ref.set(entry.toMap());
  }

  Future<void> update(String uid, Expense entry) async {
    await _db.expensesRef(uid).doc(entry.id).set(entry.toMap());
  }

  Future<void> delete(String uid, String id) async {
    await _db.expensesRef(uid).doc(id).delete();
  }

  void dispose() {
    // No local resources to release; Firestore streams are cancelled by the
    // provider that owns this service.
  }
}
