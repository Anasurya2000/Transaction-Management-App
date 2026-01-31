import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:transaction_management_app/data/api/transaction_api.dart';
import 'package:transaction_management_app/data/models/transaction_model.dart';
import 'package:transaction_management_app/data/repository/transaction_repository.dart';
import 'package:transaction_management_app/main.dart';
import 'package:transaction_management_app/presentation/providers/add_transaction_form_provider.dart';
import 'package:transaction_management_app/presentation/providers/transaction_provider.dart';
import 'package:transaction_management_app/presentation/screens/add_transaction_screen.dart';
import 'package:transaction_management_app/presentation/screens/transaction_screen.dart';
import 'fake_transaction_api.dart';

void main() {
  group('TransactionManagementApp', () {
    testWidgets('App launches and shows Transaction title', (WidgetTester tester) async {
      await tester.pumpWidget(const TransactionManagementApp());
      await tester.pumpAndSettle();
      expect(find.text('Transaction'), findsWidgets);
    });
  });

  group('TransactionScreen', () {
    testWidgets('shows Total Balance card when data is loaded', (WidgetTester tester) async {
      final response = TransactionApiResponse(
        totalBalance: 1234.56,
        totalIncome: 2000,
        totalExpense: 765.44,
        transactions: [],
      );
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi(response: response)),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const TransactionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('\$1234.56'), findsOneWidget);
    });

    testWidgets('shows Income and Expense summary cards when loaded', (WidgetTester tester) async {
      final response = TransactionApiResponse(
        totalBalance: 500,
        totalIncome: 1000,
        totalExpense: 500,
        transactions: [],
      );
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi(response: response)),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const TransactionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expense'), findsOneWidget);
      expect(find.text('\$1000.00'), findsWidgets);
      expect(find.text('\$500.00'), findsWidgets);
    });

    testWidgets('shows error and Retry button when API fails', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi(throws: true)),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const TransactionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('Retry button can be tapped without crashing', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi(throws: true)),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const TransactionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('shows transaction list when API returns transactions', (WidgetTester tester) async {
      final response = TransactionApiResponse(
        totalBalance: 100,
        totalIncome: 100,
        totalExpense: 0,
        transactions: [
          TransactionModel(
            id: '1',
            type: 'income',
            title: 'Salary Jan',
            message: 'Monthly',
            amount: 100,
            date: DateTime(2025, 1, 15),
          ),
        ],
      );
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi(response: response)),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const TransactionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Salary Jan'), findsOneWidget);
      expect(find.text('+100.00'), findsOneWidget);
    });

    testWidgets('FAB opens Add Transaction screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi()),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const TransactionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Add Transaction'), findsOneWidget);
    });

    testWidgets('shows notification icon in header', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi()),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const TransactionScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });
  });

  group('AddTransactionScreen', () {
    testWidgets('shows form fields and Save button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi()),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const AddTransactionScreen(nextId: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Add Transaction'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Transaction Type'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('back button pops screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi()),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: Builder(
              builder: (context) => Scaffold(
                body: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider(
                                create: (_) => TransactionProvider(
                                  repo: TransactionRepository(api: FakeTransactionApi()),
                                ),
                              ),
                              ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
                            ],
                            child: const AddTransactionScreen(nextId: 1),
                          ),
                        ),
                      ),
                      child: const Text('Open'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Add Transaction'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('Add Transaction'), findsNothing);
    });

    testWidgets('Save with empty title shows snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi()),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const AddTransactionScreen(nextId: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('amount_field')), '100');
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('Save with invalid amount shows snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi()),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const AddTransactionScreen(nextId: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('title_field')), 'Test Expense');
      await tester.enterText(find.byKey(const Key('amount_field')), 'abc');
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(find.text('Please enter a valid amount'), findsOneWidget);
    });

    testWidgets('Save with zero amount shows snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => TransactionProvider(
                repo: TransactionRepository(api: FakeTransactionApi()),
              ),
            ),
            ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
          ],
          child: MaterialApp(
            theme: ThemeData(useMaterial3: true),
            home: const AddTransactionScreen(nextId: 1),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('title_field')), 'Test');
      await tester.enterText(find.byKey(const Key('amount_field')), '0');
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(find.text('Please enter a valid amount'), findsOneWidget);
    });
  });
}
