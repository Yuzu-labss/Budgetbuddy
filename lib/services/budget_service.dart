import '../config/constants.dart';
import '../models/budget.dart';
import 'database_service.dart';

/// Persists a user's budget in Firestore under `users/{uid}/budgets/current`,
/// so every account owns its own budget within the shared Firebase project.
class BudgetService {
  BudgetService({DatabaseService? database})
    : _db = database ?? DatabaseService();

  final DatabaseService _db;

  Future<Budget> getBudget(String uid) async {
    final snap = await _db.budgetsRef(uid).doc(kBudgetDocId).get();
    final data = snap.data();
    if (!snap.exists || data == null) return const Budget();
    return Budget.fromMap(data);
  }

  Future<void> saveBudget(String uid, Budget budget) async {
    await _db.budgetsRef(uid).doc(kBudgetDocId).set(budget.toMap());
  }
}
