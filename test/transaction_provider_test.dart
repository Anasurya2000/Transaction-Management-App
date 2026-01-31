import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_management_app/data/api/transaction_api.dart';
import 'package:transaction_management_app/data/models/transaction_model.dart';
import 'package:transaction_management_app/data/repository/transaction_repository.dart';
import 'package:transaction_management_app/presentation/providers/transaction_provider.dart';
import 'fake_transaction_api.dart';

void main() {
  group('TransactionProvider', () {
    late TransactionProvider provider;

    setUp(() {
      provider = TransactionProvider(repo: TransactionRepository(api: FakeTransactionApi()));
    });

    group('initial state', () {
      test('transactions is empty', () {
        expect(provider.transactions, isEmpty);
      });
      test('totalBalance is 0', () => expect(provider.totalBalance, 0));
      test('totalIncome is 0', () => expect(provider.totalIncome, 0));
      test('totalExpense is 0', () => expect(provider.totalExpense, 0));
      test('loading is true', () => expect(provider.loading, true));
      test('error is null', () => expect(provider.error, isNull));
    });

    group('loadFromApi', () {
      test('sets loading then loads data and clears loading', () async {
        final response = TransactionApiResponse(
          totalBalance: 500,
          totalIncome: 1000,
          totalExpense: 500,
          transactions: [
            TransactionModel(
              id: '1',
              type: 'income',
              title: 'Salary',
              message: '',
              amount: 1000,
              date: DateTime(2025, 1, 15),
            ),
            TransactionModel(
              id: '2',
              type: 'expense',
              title: 'Rent',
              message: '',
              amount: 500,
              date: DateTime(2025, 1, 10),
            ),
          ],
        );
        provider = TransactionProvider(
          repo: TransactionRepository(api: FakeTransactionApi(response: response)),
        );
        await provider.loadFromApi();
        expect(provider.loading, false);
        expect(provider.error, isNull);
        expect(provider.totalBalance, 500);
        expect(provider.totalIncome, 1000);
        expect(provider.totalExpense, 500);
        expect(provider.transactions.length, 2);
        expect(provider.transactions.first.title, 'Salary');
      });

      test('sorts transactions by date descending', () async {
        final response = TransactionApiResponse(
          totalBalance: 0,
          totalIncome: 100,
          totalExpense: 100,
          transactions: [
            TransactionModel(id: '1', type: 'income', title: 'A', message: '', amount: 100, date: DateTime(2025, 1, 1)),
            TransactionModel(id: '2', type: 'income', title: 'B', message: '', amount: 100, date: DateTime(2025, 1, 15)),
          ],
        );
        provider = TransactionProvider(
          repo: TransactionRepository(api: FakeTransactionApi(response: response)),
        );
        await provider.loadFromApi();
        expect(provider.transactions.first.date, DateTime(2025, 1, 15));
        expect(provider.transactions.last.date, DateTime(2025, 1, 1));
      });

      test('sets error when API throws', () async {
        provider = TransactionProvider(
          repo: TransactionRepository(api: FakeTransactionApi(throws: true)),
        );
        await provider.loadFromApi();
        expect(provider.loading, false);
        expect(provider.error, isNotNull);
        expect(provider.error, contains('Failed'));
      });
    });

    group('addTransaction', () {
      test('adds income and updates totals', () async {
        provider = TransactionProvider(
          repo: TransactionRepository(api: FakeTransactionApi(response: TransactionApiResponse(totalBalance: 0, totalIncome: 0, totalExpense: 0, transactions: []))),
        );
        await provider.loadFromApi();
        final tx = TransactionModel(
          id: 'local_1',
          type: 'income',
          title: 'Freelance',
          message: '',
          amount: 300,
          date: DateTime(2025, 1, 20),
        );
        provider.addTransaction(tx);
        expect(provider.transactions.length, 1);
        expect(provider.transactions.first.title, 'Freelance');
        expect(provider.totalIncome, 300);
        expect(provider.totalBalance, 300);
        expect(provider.totalExpense, 0);
      });

      test('adds expense and updates totals', () async {
        provider = TransactionProvider(
          repo: TransactionRepository(api: FakeTransactionApi(response: TransactionApiResponse(totalBalance: 500, totalIncome: 1000, totalExpense: 500, transactions: []))),
        );
        await provider.loadFromApi();
        final tx = TransactionModel(
          id: 'local_1',
          type: 'expense',
          title: 'Shopping',
          message: '',
          amount: 100,
          date: DateTime(2025, 1, 20),
        );
        provider.addTransaction(tx);
        expect(provider.totalExpense, 600);
        expect(provider.totalBalance, 400);
      });

      test('prepends new transaction to list', () async {
        final response = TransactionApiResponse(
          totalBalance: 0,
          totalIncome: 100,
          totalExpense: 100,
          transactions: [
            TransactionModel(id: '1', type: 'income', title: 'Old', message: '', amount: 100, date: DateTime(2025, 1, 1)),
          ],
        );
        provider = TransactionProvider(
          repo: TransactionRepository(api: FakeTransactionApi(response: response)),
        );
        await provider.loadFromApi();
        provider.addTransaction(TransactionModel(
          id: 'local_1',
          type: 'income',
          title: 'New',
          message: '',
          amount: 50,
          date: DateTime(2025, 1, 20),
        ));
        expect(provider.transactions.first.title, 'New');
      });
    });

    group('transactionsByMonth', () {
      test('groups by month key', () async {
        final response = TransactionApiResponse(
          totalBalance: 0,
          totalIncome: 200,
          totalExpense: 0,
          transactions: [
            TransactionModel(id: '1', type: 'income', title: 'A', message: '', amount: 100, date: DateTime(2025, 1, 5)),
            TransactionModel(id: '2', type: 'income', title: 'B', message: '', amount: 100, date: DateTime(2025, 1, 15)),
            TransactionModel(id: '3', type: 'income', title: 'C', message: '', amount: 100, date: DateTime(2025, 2, 1)),
          ],
        );
        provider = TransactionProvider(
          repo: TransactionRepository(api: FakeTransactionApi(response: response)),
        );
        await provider.loadFromApi();
        final byMonth = provider.transactionsByMonth;
        expect(byMonth.length, 2);
        expect(byMonth['2025-01']!.length, 2);
        expect(byMonth['2025-02']!.length, 1);
      });

      test('months ordered latest first', () async {
        final response = TransactionApiResponse(
          totalBalance: 0,
          totalIncome: 200,
          totalExpense: 0,
          transactions: [
            TransactionModel(id: '1', type: 'income', title: 'A', message: '', amount: 100, date: DateTime(2025, 1, 1)),
            TransactionModel(id: '2', type: 'income', title: 'B', message: '', amount: 100, date: DateTime(2025, 2, 1)),
          ],
        );
        provider = TransactionProvider(
          repo: TransactionRepository(api: FakeTransactionApi(response: response)),
        );
        await provider.loadFromApi();
        final keys = provider.transactionsByMonth.keys.toList();
        expect(keys.first, '2025-02');
        expect(keys.last, '2025-01');
      });
    });

    group('getNextId', () {
      test('increments each call', () {
        expect(provider.getNextId(), 1);
        expect(provider.getNextId(), 2);
        expect(provider.getNextId(), 3);
      });
    });
  });
}

