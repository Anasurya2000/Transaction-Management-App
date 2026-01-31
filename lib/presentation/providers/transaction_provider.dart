import 'package:flutter/foundation.dart';

import '../../data/models/transaction_model.dart';
import '../../data/repository/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  TransactionProvider({TransactionRepository? repo})
    : _repo = repo ?? TransactionRepository();

  final TransactionRepository _repo;

  List<TransactionModel> _transactions = [];
  double _totalBalance = 0;
  double _totalIncome = 0;
  double _totalExpense = 0;
  bool _loading = true;
  String? _error;

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  double get totalBalance => _totalBalance;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  bool get loading => _loading;
  String? get error => _error;

  /// Groups transactions by month. Months and transactions within each month
  /// are ordered latest first (most recent at top).
  Map<String, List<TransactionModel>> get transactionsByMonth {
    final map = <String, List<TransactionModel>>{};
    for (final t in _transactions) {
      map.putIfAbsent(t.monthKey, () => []).add(t);
    }
    for (final list in map.values) {
      list.sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        return byDate != 0 ? byDate : b.id.compareTo(a.id);
      });
    }
    final keys = map.keys.toList()..sort((a, b) => b.compareTo(a));
    return Map.fromEntries(keys.map((k) => MapEntry(k, map[k]!)));
  }

  Future<void> loadFromApi() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _repo.loadTransactions();
      _transactions = res.transactions
        ..sort((a, b) {
          final byDate = b.date.compareTo(a.date);
          return byDate != 0 ? byDate : b.id.compareTo(a.id);
        });
      _totalBalance = res.totalBalance;
      _totalIncome = res.totalIncome;
      _totalExpense = res.totalExpense;
    } catch (e) {
      _error = e is Exception ? e.toString() : 'Failed to load transactions';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void addTransaction(TransactionModel transaction) {
    _transactions = [transaction, ..._transactions];
    if (transaction.isIncome) {
      _totalIncome += transaction.amount;
      _totalBalance += transaction.amount;
    } else {
      _totalExpense += transaction.amount;
      _totalBalance -= transaction.amount;
    }
    notifyListeners();
  }

  int _nextId = 0;

  int getNextId() => ++_nextId;
}
