import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_management_app/data/api/transaction_api.dart';
import 'package:transaction_management_app/data/models/transaction_model.dart';
import 'package:transaction_management_app/data/repository/transaction_repository.dart';
import 'fake_transaction_api.dart';

void main() {
  group('TransactionRepository', () {
    test('loadTransactions returns API response when API succeeds', () async {
      final response = TransactionApiResponse(
        totalBalance: 100,
        totalIncome: 200,
        totalExpense: 100,
        transactions: [
          TransactionModel(
            id: '1',
            type: 'income',
            title: 'Test',
            message: '',
            amount: 200,
            date: DateTime(2025, 1, 1),
          ),
        ],
      );
      final repo = TransactionRepository(api: FakeTransactionApi(response: response));
      final result = await repo.loadTransactions();
      expect(result.totalBalance, 100);
      expect(result.totalIncome, 200);
      expect(result.totalExpense, 100);
      expect(result.transactions.length, 1);
      expect(result.transactions.first.title, 'Test');
    });

    test('loadTransactions throws when API throws', () async {
      final repo = TransactionRepository(api: FakeTransactionApi(throws: true));
      expect(
        () => repo.loadTransactions(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed'),
        )),
      );
    });
  });
}
