import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_management_app/main.dart';

void main() {
  testWidgets('App shows Transaction title', (WidgetTester tester) async {
    await tester.pumpWidget(const TransactionManagementApp());
    await tester.pumpAndSettle();
    expect(find.text('Transaction'), findsWidgets);
  });
}
