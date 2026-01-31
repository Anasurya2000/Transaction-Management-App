import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_management_app/data/models/transaction_model.dart';

void main() {
  group('TransactionModel', () {
    group('fromJson', () {
      test('parses valid full JSON', () {
        final json = {
          'id': 'tx_1',
          'type': 'income',
          'title': 'Salary',
          'message': 'Monthly pay',
          'amount': 5000.50,
          'date': '2025-01-15T10:30:00.000',
        };
        final t = TransactionModel.fromJson(json);
        expect(t.id, 'tx_1');
        expect(t.type, 'income');
        expect(t.title, 'Salary');
        expect(t.message, 'Monthly pay');
        expect(t.amount, 5000.50);
        expect(t.date, DateTime(2025, 1, 15, 10, 30));
      });

      test('parses expense type', () {
        final t = TransactionModel.fromJson({
          'id': 'e1',
          'type': 'expense',
          'title': 'Rent',
          'message': 'House',
          'amount': 1200,
          'date': '2025-01-01T00:00:00.000',
        });
        expect(t.type, 'expense');
        expect(t.isIncome, false);
      });

      test('normalizes type to lowercase', () {
        final t = TransactionModel.fromJson({
          'id': 'e1',
          'type': 'INCOME',
          'title': 'X',
          'message': '',
          'amount': 100,
          'date': '2025-01-01T00:00:00.000',
        });
        expect(t.type, 'income');
      });

      test('handles missing optional fields with defaults', () {
        final t = TransactionModel.fromJson({});
        expect(t.id, '');
        expect(t.type, 'expense');
        expect(t.title, '');
        expect(t.message, '');
        expect(t.amount, 0);
        expect(t.date, isNotNull);
      });

      test('handles null values', () {
        final t = TransactionModel.fromJson({
          'id': null,
          'type': null,
          'title': null,
          'message': null,
          'amount': null,
          'date': null,
        });
        expect(t.id, '');
        expect(t.type, 'expense');
        expect(t.title, '');
        expect(t.message, '');
        expect(t.amount, 0);
      });

      test('parses amount as int', () {
        final t = TransactionModel.fromJson({
          'id': '1',
          'type': 'expense',
          'title': 'X',
          'message': '',
          'amount': 99,
          'date': '2025-01-01T00:00:00.000',
        });
        expect(t.amount, 99.0);
      });

      test('handles invalid date string', () {
        final t = TransactionModel.fromJson({
          'id': '1',
          'type': 'expense',
          'title': 'X',
          'message': '',
          'amount': 0,
          'date': 'invalid',
        });
        expect(t.date, isNotNull);
      });

      test('handles empty date string', () {
        final t = TransactionModel.fromJson({
          'id': '1',
          'type': 'expense',
          'title': 'X',
          'message': '',
          'amount': 0,
          'date': '',
        });
        expect(t.date, isNotNull);
      });
    });

    group('isIncome', () {
      test('true when type is income', () {
        final t = TransactionModel(
          id: '1',
          type: 'income',
          title: 'X',
          message: '',
          amount: 100,
          date: DateTime(2025, 1, 1),
        );
        expect(t.isIncome, true);
      });

      test('false when type is expense', () {
        final t = TransactionModel(
          id: '1',
          type: 'expense',
          title: 'X',
          message: '',
          amount: 100,
          date: DateTime(2025, 1, 1),
        );
        expect(t.isIncome, false);
      });
    });

    group('formattedAmount', () {
      test('income shows plus prefix', () {
        final t = TransactionModel(
          id: '1',
          type: 'income',
          title: 'X',
          message: '',
          amount: 123.45,
          date: DateTime(2025, 1, 1),
        );
        expect(t.formattedAmount, '+123.45');
      });

      test('expense shows minus prefix', () {
        final t = TransactionModel(
          id: '1',
          type: 'expense',
          title: 'X',
          message: '',
          amount: 50.5,
          date: DateTime(2025, 1, 1),
        );
        expect(t.formattedAmount, '-50.50');
      });
    });

    group('timeString', () {
      test('formats hour and minute with leading zeros', () {
        final t = TransactionModel(
          id: '1',
          type: 'expense',
          title: 'X',
          message: '',
          amount: 0,
          date: DateTime(2025, 1, 1, 9, 5),
        );
        expect(t.timeString, '09:05');
      });
    });

    group('dateString', () {
      test('formats as short month and day', () {
        final t = TransactionModel(
          id: '1',
          type: 'expense',
          title: 'X',
          message: '',
          amount: 0,
          date: DateTime(2025, 3, 15),
        );
        expect(t.dateString, 'Mar 15');
      });
    });

    group('monthKey', () {
      test('formats as YYYY-MM', () {
        final t = TransactionModel(
          id: '1',
          type: 'expense',
          title: 'X',
          message: '',
          amount: 0,
          date: DateTime(2025, 1, 15),
        );
        expect(t.monthKey, '2025-01');
      });

      test('pads month with zero', () {
        final t = TransactionModel(
          id: '1',
          type: 'expense',
          title: 'X',
          message: '',
          amount: 0,
          date: DateTime(2025, 9, 1),
        );
        expect(t.monthKey, '2025-09');
      });
    });

    group('monthNames', () {
      test('has 12 months', () {
        expect(TransactionModel.monthNames.length, 12);
      });
      test('first is January', () {
        expect(TransactionModel.monthNames.first, 'January');
      });
      test('last is December', () {
        expect(TransactionModel.monthNames.last, 'December');
      });
    });
  });
}
