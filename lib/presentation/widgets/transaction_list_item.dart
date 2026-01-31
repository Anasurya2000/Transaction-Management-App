import 'package:flutter/material.dart';

import '../../Core/Constants/app_colors.dart';
import '../../data/models/transaction_model.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({super.key, required this.transaction});

  final TransactionModel transaction;

  static IconData _iconForTransaction(TransactionModel t) {
    final lower = '${t.title} ${t.message}'.toLowerCase();
    if (lower.contains('salary') ||
        lower.contains('income') ||
        lower.contains('freelance')) {
      return Icons.payments;
    }
    if (lower.contains('rent') || lower.contains('house')) {
      return Icons.home;
    }
    if (lower.contains('fuel') ||
        lower.contains('car') ||
        lower.contains('transport')) {
      return Icons.directions_bus;
    }
    if (lower.contains('dining') || lower.contains('restaurant')) {
      return Icons.restaurant;
    }
    if (lower.contains('grocery') || lower.contains('shopping')) {
      return Icons.shopping_cart;
    }
    if (lower.contains('electricity') || lower.contains('internet')) {
      return Icons.bolt;
    }
    if (t.isIncome) {
      return Icons.payments;
    }
    return Icons.receipt_long;
  }

  @override
  Widget build(BuildContext context) {
    final amountColor = transaction.isIncome
        ? AppColors.textPrimary
        : AppColors.expenseBlue;
    final divider = Container(width: 1, color: AppColors.separatorGreen);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.iconCircleBlue,
                ),
                child: Icon(
                  _iconForTransaction(transaction),
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${transaction.timeString} - ${transaction.dateString}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDateBlueGray,
                    ),
                  ),
                ],
              ),
            ),
            divider,
            if (transaction.message.isNotEmpty) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Center(
                  child: Text(
                    transaction.message,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ] else
              const SizedBox(width: 12),
            divider,
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  transaction.formattedAmount,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: amountColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
