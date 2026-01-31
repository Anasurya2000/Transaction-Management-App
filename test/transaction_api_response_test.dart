import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_management_app/data/api/transaction_api.dart';

void main() {
  group('TransactionApiResponse', () {
    group('fromJson', () {
      test('parses valid full response', () {
        final json = {
          'data': {
            'summary': {
              'totalBalance': 1000.50,
              'totalIncome': 2000.0,
              'totalExpense': 999.50,
            },
            'transactions': [
              {
                'id': 'tx_1',
                'type': 'income',
                'title': 'Salary',
                'message': 'Pay',
                'amount': 2000.0,
                'date': '2025-01-15T00:00:00.000',
              },
            ],
          },
        };
        final res = TransactionApiResponse.fromJson(json);
        expect(res.totalBalance, 1000.50);
        expect(res.totalIncome, 2000.0);
        expect(res.totalExpense, 999.50);
        expect(res.transactions.length, 1);
        expect(res.transactions.first.id, 'tx_1');
        expect(res.transactions.first.title, 'Salary');
      });

      test('handles empty data', () {
        final res = TransactionApiResponse.fromJson({'data': <String, dynamic>{}});
        expect(res.totalBalance, 0);
        expect(res.totalIncome, 0);
        expect(res.totalExpense, 0);
        expect(res.transactions, isEmpty);
      });

      test('handles missing data key', () {
        final res = TransactionApiResponse.fromJson({});
        expect(res.totalBalance, 0);
        expect(res.totalIncome, 0);
        expect(res.totalExpense, 0);
        expect(res.transactions, isEmpty);
      });

      test('handles null summary fields', () {
        final json = <String, dynamic>{
          'data': <String, dynamic>{
            'summary': <String, dynamic>{},
            'transactions': <dynamic>[],
          },
        };
        final res = TransactionApiResponse.fromJson(json);
        expect(res.totalBalance, 0);
        expect(res.totalIncome, 0);
        expect(res.totalExpense, 0);
      });

      test('parses multiple transactions', () {
        final json = {
          'data': {
            'summary': {
              'totalBalance': 500,
              'totalIncome': 1000,
              'totalExpense': 500,
            },
            'transactions': [
              {'id': '1', 'type': 'income', 'title': 'A', 'message': '', 'amount': 1000, 'date': '2025-01-01'},
              {'id': '2', 'type': 'expense', 'title': 'B', 'message': '', 'amount': 500, 'date': '2025-01-02'},
            ],
          },
        };
        final res = TransactionApiResponse.fromJson(json);
        expect(res.transactions.length, 2);
        expect(res.transactions[0].title, 'A');
        expect(res.transactions[1].title, 'B');
      });
    });
  });
}
