import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Constants/app_colors.dart';
import '../../data/models/transaction_model.dart';
import '../providers/add_transaction_form_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/transaction_list_item.dart';
import 'add_transaction_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadFromApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryMint,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Consumer<TransactionProvider>(
                builder: (context, provider, _) {
                  if (provider.error != null) {
                    return _buildError(provider.error!);
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _TotalBalanceCard(amount: provider.totalBalance),
                              const SizedBox(height: 20),
                              _SummaryCards(provider: provider),
                            ],
                          ),
                        ),
                        _TransactionsSection(provider: provider),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const SizedBox(width: 48),
          const Expanded(
            child: Text(
              'Transaction',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () =>
                  context.read<TransactionProvider>().loadFromApi(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _openAddTransaction(context),
      backgroundColor: AppColors.primaryMint,
      elevation: 4,
      child: const Icon(Icons.add, color: AppColors.textPrimary, size: 28),
    );
  }

  void _openAddTransaction(BuildContext context) async {
    context.read<AddTransactionFormProvider>().reset();
    final provider = context.read<TransactionProvider>();
    final nextId = provider.getNextId();
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (context) => AddTransactionScreen(nextId: nextId),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_outlined, selected: false),
              _NavItem(icon: Icons.show_chart, selected: false),
              _NavItem(icon: Icons.swap_horiz, selected: true),
              _NavItem(icon: Icons.assignment_outlined, selected: false),
              _NavItem(icon: Icons.person_outline, selected: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalBalanceCard extends StatelessWidget {
  const _TotalBalanceCard({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.provider});

  final TransactionProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _IncomeSummaryCard(amount: provider.totalIncome)),
        const SizedBox(width: 12),
        Expanded(child: _ExpenseSummaryCard(amount: provider.totalExpense)),
      ],
    );
  }
}

class _IncomeSummaryCard extends StatelessWidget {
  const _IncomeSummaryCard({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.incomeGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.incomeGreen, width: 1),
            ),
            child: const Icon(
              Icons.trending_up,
              color: AppColors.incomeGreen,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Income',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseSummaryCard extends StatelessWidget {
  const _ExpenseSummaryCard({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.expenseBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: const Icon(
              Icons.trending_down,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Expense',
            style: TextStyle(fontSize: 13, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionsSection extends StatelessWidget {
  const _TransactionsSection({required this.provider});

  final TransactionProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final byMonth = provider.transactionsByMonth;
    if (byMonth.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.sectionPaleGreen,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const Center(
          child: Text(
            'No transactions',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.sectionPaleGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...byMonth.entries.map(
            (e) => _MonthGroup(
              monthLabel: _monthLabelFromKey(e.key),
              transactions: e.value,
            ),
          ),
        ],
      ),
    );
  }

  String _monthLabelFromKey(String key) {
    final parts = key.split('-');
    if (parts.length != 2) return key;
    final month = int.tryParse(parts[1]) ?? 0;
    if (month < 1 || month > 12) return key;
    return TransactionModel.monthNames[month - 1];
  }
}

class _MonthGroup extends StatelessWidget {
  const _MonthGroup({required this.monthLabel, required this.transactions});

  final String monthLabel;
  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                monthLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryMint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.separatorGreen, width: 1),
                ),
                child: IconButton(
                  onPressed: () =>
                      context.read<TransactionProvider>().loadFromApi(),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: AppColors.primaryMint,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...transactions.map((t) => TransactionListItem(transaction: t)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.selected});

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: selected
          ? BoxDecoration(color: AppColors.primaryMint, shape: BoxShape.circle)
          : null,
      child: Icon(
        icon,
        size: 24,
        color: selected ? AppColors.textPrimary : AppColors.textSecondary,
      ),
    );
  }
}
