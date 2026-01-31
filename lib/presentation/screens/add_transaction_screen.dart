import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Core/Constants/app_colors.dart';
import '../../data/models/transaction_model.dart';
import '../providers/add_transaction_form_provider.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key, required this.nextId});

  final int nextId;

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _otherCategoryController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    _otherCategoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final form = context.read<AddTransactionFormProvider>();
    final picked = await showDatePicker(
      context: context,
      initialDate: form.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) form.updateDate(picked);
  }

  void _save(BuildContext context) {
    final form = context.read<AddTransactionFormProvider>();
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final category = form.selectedCategory == 'Other'
        ? (_otherCategoryController.text.trim().isEmpty
              ? 'Other'
              : _otherCategoryController.text.trim())
        : (form.selectedCategory ?? 'Other');
    final message = _messageController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    final transaction = TransactionModel(
      id: 'local_${widget.nextId}',
      type: form.isIncome ? 'income' : 'expense',
      title: title,
      message: message.isEmpty ? category : message,
      amount: amount,
      date: form.selectedDate,
    );
    context.read<TransactionProvider>().addTransaction(transaction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryMint,
      appBar: AppBar(
        backgroundColor: AppColors.primaryMint,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.cardWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Consumer<AddTransactionFormProvider>(
                builder: (context, form, _) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _FormLabel('Date'),
                        const SizedBox(height: 8),
                        _DateField(
                          date: form.selectedDate,
                          onTap: () => _pickDate(context),
                        ),
                        const SizedBox(height: 20),
                        _FormLabel('Transaction Type'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          initialValue: form.isIncome ? 'Income' : 'Expense',
                          decoration: _inputDecoration(),
                          items: const [
                            DropdownMenuItem(
                              value: 'Expense',
                              child: Text('Expense'),
                            ),
                            DropdownMenuItem(
                              value: 'Income',
                              child: Text('Income'),
                            ),
                          ],
                          onChanged: (v) =>
                              form.setTransactionType(v == 'Income'),
                        ),
                        const SizedBox(height: 20),
                        _FormLabel('Category'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String?>(
                          initialValue:
                              form.categories.contains(form.selectedCategory)
                              ? form.selectedCategory
                              : null,
                          decoration: _inputDecoration(),
                          hint: const Text('Select Category'),
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text('Select Category'),
                            ),
                            ...form.categories.map(
                              (c) => DropdownMenuItem<String?>(
                                value: c,
                                child: Text(c),
                              ),
                            ),
                          ],
                          onChanged: form.setCategory,
                        ),
                        if (form.selectedCategory == 'Other') ...[
                          const SizedBox(height: 20),
                          _FormLabel('Enter Category'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _otherCategoryController,
                            decoration: _inputDecoration(
                              hint: 'Enter category name',
                            ),
                            textCapitalization: TextCapitalization.words,
                          ),
                        ],
                        const SizedBox(height: 20),
                        _FormLabel('Amount'),
                        const SizedBox(height: 8),
                        TextField(
                          key: const Key('amount_field'),
                          controller: _amountController,
                          decoration: _inputDecoration(
                            hint: '0.00',
                            prefixText: '\$ ',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FormLabel('Expense Title'),
                        const SizedBox(height: 8),
                        TextField(
                          key: const Key('title_field'),
                          controller: _titleController,
                          decoration: _inputDecoration(
                            hint: 'e.g. House Rental Income',
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Enter Message',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryMint,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _messageController,
                          decoration: _inputDecoration(
                            hint: 'Enter Description',
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: () => _save(context),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryMintDark,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint, String? prefixText}) {
    return InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label =
        '${TransactionModel.monthNames[date.month - 1]} ${date.day}, ${date.year}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.tagBackground),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
