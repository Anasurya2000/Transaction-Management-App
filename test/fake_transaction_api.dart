import 'package:transaction_management_app/data/api/transaction_api.dart';

/// Fake [TransactionApi] for tests. Override [response] and [throws] to control behavior.
class FakeTransactionApi extends TransactionApi {
  FakeTransactionApi({TransactionApiResponse? response, bool throws = false})
      : _response = response,
        _throws = throws;

  final TransactionApiResponse? _response;
  final bool _throws;

  @override
  Future<TransactionApiResponse> fetchTransactions() async {
    if (_throws) throw Exception('Failed to load transactions');
    return _response ??
        TransactionApiResponse(
          totalBalance: 0,
          totalIncome: 0,
          totalExpense: 0,
          transactions: [],
        );
  }
}
