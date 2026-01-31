import '../api/transaction_api.dart';

class TransactionRepository {
  TransactionRepository({TransactionApi? api}) : _api = api ?? TransactionApi();

  final TransactionApi _api;

  Future<TransactionApiResponse> loadTransactions() => _api.fetchTransactions();
}
