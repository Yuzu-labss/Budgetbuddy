import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _service;
  final bool _ownsService;
  ExpenseProvider({ExpenseService? service})
      : _service = service ?? ExpenseService(),
        _ownsService = service == null;

  StreamSubscription<List<Expense>>? _sub;
  String? _uid;
  List<Expense> _expenses = [];
  bool _loading = false;
  String? _error;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _loading;
  String? get error => _error;

  void start(String? uid) {
    if (uid == _uid) return;
    _sub?.cancel();
    _uid = uid;
    _expenses = [];
    _error = null;
    if (uid == null) {
      _loading = false;
      Future.microtask(notifyListeners);
      return;
    }
    _loading = true;
    _sub = _service.watchExpenses(uid).listen(
          (list) {
        list.sort((a, b) => b.date.compareTo(a.date));
        _expenses = list;
        _loading = false;
        notifyListeners();
      },
      onError: (_) {
        _error = 'Could not load expenses.';
        _loading = false;
        notifyListeners();
      },
    );
  }

  Future<bool> add({
    required String name,
    required double amount,
    required String category,
    required DateTime date,
    required String type,
    String notes = '',
    String? receiptUrl,
  }) async {
    final uid = _uid;
    if (uid == null) {
      _error = 'Please log in again.';
      notifyListeners();
      return false;
    }
    try {
      await _service.add(
        uid,
        Expense(
          name: name,
          amount: amount,
          category: category,
          date: date,
          notes: notes,
          receiptUrl: receiptUrl,
          type: type,
        ),
      );
      return true;
    } catch (_) {
      _error = 'Could not save. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> update({
    required Expense expense,
    required String name,
    required double amount,
    required String category,
    required DateTime date,
  }) async {
    final uid = _uid;
    if (uid == null) {
      _error = 'Please log in again.';
      notifyListeners();
      return false;
    }
    try {
      await _service.update(
        uid,
        Expense(
          id: expense.id,
          name: name,
          amount: amount,
          category: category,
          date: date,
          notes: expense.notes,
          receiptUrl: expense.receiptUrl,
          createdAt: expense.createdAt,
          type: expense.type,
        ),
      );
      return true;
    } catch (_) {
      _error = 'Could not save your changes. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(Expense expense) async {
    final uid = _uid;
    if (uid == null) {
      _error = 'Please log in again.';
      notifyListeners();
      return false;
    }
    try {
      await _service.delete(uid, expense.id);
      return true;
    } catch (_) {
      _error = 'Could not delete this entry. Please try again.';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    if (_ownsService) _service.dispose();
    super.dispose();
  }
}
