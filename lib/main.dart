import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Core/Constants/app_colors.dart';
import 'presentation/providers/add_transaction_form_provider.dart';
import 'presentation/providers/transaction_provider.dart';
import 'presentation/screens/transaction_screen.dart';

void main() {
  runApp(const TransactionManagementApp());
}

class TransactionManagementApp extends StatelessWidget {
  const TransactionManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => AddTransactionFormProvider()),
      ],
      child: MaterialApp(
        title: 'Transaction Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryMintDark,
          ),
          useMaterial3: true,
        ),
        home: const TransactionScreen(),
      ),
    );
  }
}
