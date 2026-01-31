import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/Constants/api_endpoints.dart';
import '../models/transaction_model.dart';

class TransactionApi {
  Future<TransactionApiResponse> fetchTransactions() async {
    final response = await http.get(Uri.parse(ApiEndpoints.transactionsUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load transactions: ${response.statusCode}');
    }
    final map = jsonDecode(response.body) as Map<String, dynamic>;
    return TransactionApiResponse.fromJson(map);
  }
}

class TransactionApiResponse {
  const TransactionApiResponse({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  });

  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final List<TransactionModel> transactions;

  factory TransactionApiResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final summary = data['summary'] as Map<String, dynamic>? ?? {};
    final list = data['transactions'] as List<dynamic>? ?? [];
    final transactions = list
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return TransactionApiResponse(
      totalBalance: (summary['totalBalance'] as num?)?.toDouble() ?? 0,
      totalIncome: (summary['totalIncome'] as num?)?.toDouble() ?? 0,
      totalExpense: (summary['totalExpense'] as num?)?.toDouble() ?? 0,
      transactions: transactions,
    );
  }
}
