import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_management_app/data/models/transaction_model.dart';
import 'package:transaction_management_app/presentation/widgets/transaction_list_item.dart';

void main() {
  group('TransactionListItem', () {
    testWidgets('displays transaction title', (WidgetTester tester) async {
      final transaction = TransactionModel(
        id: '1',
        type: 'income',
        title: 'Salary',
        message: 'Monthly pay',
        amount: 5000,
        date: DateTime(2025, 1, 15, 10, 30),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: transaction),
          ),
        ),
      );
      expect(find.text('Salary'), findsOneWidget);
    });

    testWidgets('displays formatted amount for income with plus', (WidgetTester tester) async {
      final transaction = TransactionModel(
        id: '1',
        type: 'income',
        title: 'Freelance',
        message: '',
        amount: 250.50,
        date: DateTime(2025, 1, 1),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: transaction),
          ),
        ),
      );
      expect(find.text('+250.50'), findsOneWidget);
    });

    testWidgets('displays formatted amount for expense with minus', (WidgetTester tester) async {
      final transaction = TransactionModel(
        id: '1',
        type: 'expense',
        title: 'Rent',
        message: 'House',
        amount: 1200,
        date: DateTime(2025, 1, 1),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: transaction),
          ),
        ),
      );
      expect(find.text('-1200.00'), findsOneWidget);
    });

    testWidgets('displays time and date string', (WidgetTester tester) async {
      final transaction = TransactionModel(
        id: '1',
        type: 'expense',
        title: 'Coffee',
        message: '',
        amount: 5,
        date: DateTime(2025, 3, 15, 9, 5),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: transaction),
          ),
        ),
      );
      expect(find.text('09:05 - Mar 15'), findsOneWidget);
    });

    testWidgets('displays message when not empty', (WidgetTester tester) async {
      final transaction = TransactionModel(
        id: '1',
        type: 'income',
        title: 'Salary',
        message: 'January bonus',
        amount: 1000,
        date: DateTime(2025, 1, 1),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionListItem(transaction: transaction),
          ),
        ),
      );
      expect(find.text('January bonus'), findsOneWidget);
    });
  });
}
