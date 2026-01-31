import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_management_app/presentation/providers/add_transaction_form_provider.dart';

void main() {
  group('AddTransactionFormProvider', () {
    late AddTransactionFormProvider provider;

    setUp(() {
      provider = AddTransactionFormProvider();
    });

    group('initial state', () {
      test('isIncome is false', () => expect(provider.isIncome, false));
      test('selectedCategory is null', () => expect(provider.selectedCategory, isNull));
      test('selectedDate is set', () => expect(provider.selectedDate, isNotNull));
    });

    group('categories', () {
      test('when isIncome false returns expense categories', () {
        expect(provider.categories, AddTransactionFormProvider.expenseCategories);
        expect(provider.categories, contains('Restaurant'));
        expect(provider.categories, contains('House rent'));
      });

      test('when isIncome true returns income categories', () {
        provider.setTransactionType(true);
        expect(provider.categories, AddTransactionFormProvider.incomeCategories);
        expect(provider.categories, contains('Salary'));
        expect(provider.categories, contains('Freelance'));
      });
    });

    group('setTransactionType', () {
      test('sets isIncome to true', () {
        provider.setTransactionType(true);
        expect(provider.isIncome, true);
      });

      test('sets isIncome to false', () {
        provider.setTransactionType(true);
        provider.setTransactionType(false);
        expect(provider.isIncome, false);
      });

      test('clears selectedCategory when type changes', () {
        provider.setCategory('Salary');
        provider.setTransactionType(false);
        expect(provider.selectedCategory, isNull);
      });
    });

    group('updateDate', () {
      test('updates selectedDate', () {
        final date = DateTime(2025, 6, 15);
        provider.updateDate(date);
        expect(provider.selectedDate, date);
      });
    });

    group('setCategory', () {
      test('sets selectedCategory', () {
        provider.setCategory('Restaurant');
        expect(provider.selectedCategory, 'Restaurant');
      });

      test('allows null', () {
        provider.setCategory('Restaurant');
        provider.setCategory(null);
        expect(provider.selectedCategory, isNull);
      });
    });

    group('reset', () {
      test('resets to default state', () {
        provider.setTransactionType(true);
        provider.setCategory('Salary');
        provider.updateDate(DateTime(2024, 1, 1));
        provider.reset();
        expect(provider.isIncome, false);
        expect(provider.selectedCategory, isNull);
        expect(provider.selectedDate.year, DateTime.now().year);
      });
    });

    group('incomeCategories', () {
      test('has expected items', () {
        expect(AddTransactionFormProvider.incomeCategories, contains('Salary'));
        expect(AddTransactionFormProvider.incomeCategories, contains('Gift'));
        expect(AddTransactionFormProvider.incomeCategories, contains('Other'));
      });
    });

    group('expenseCategories', () {
      test('has expected items', () {
        expect(AddTransactionFormProvider.expenseCategories, contains('House rent'));
        expect(AddTransactionFormProvider.expenseCategories, contains('Shopping'));
        expect(AddTransactionFormProvider.expenseCategories, contains('Other'));
      });
    });
  });
}
