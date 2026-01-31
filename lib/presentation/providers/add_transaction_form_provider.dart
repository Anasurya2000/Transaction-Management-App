import 'package:flutter/foundation.dart';

class AddTransactionFormProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  bool _isIncome = false;
  String? _selectedCategory;

  DateTime get selectedDate => _selectedDate;
  bool get isIncome => _isIncome;
  String? get selectedCategory => _selectedCategory;

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Side project',
    'Investment',
    'Gift',
    'Other',
  ];

  static const List<String> expenseCategories = [
    'Car fuel',
    'Restaurant',
    'House rent',
    'Shopping',
    'Utilities',
    'Other',
  ];

  List<String> get categories =>
      _isIncome ? incomeCategories : expenseCategories;

  void updateDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTransactionType(bool isIncome) {
    _isIncome = isIncome;
    _selectedCategory = null;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void reset() {
    _selectedDate = DateTime.now();
    _isIncome = false;
    _selectedCategory = null;
    notifyListeners();
  }
}
