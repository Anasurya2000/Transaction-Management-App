# Transaction Management App

Personal finance transaction tracker. View and add Income/Expense transactions with data from the provided API. State is managed with Provider.

## Requirements

- Flutter (latest stable)
- Dart 3.x

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/Anasurya2000/Transaction-Management-App.git
   cd transaction_management_app
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project structure

- `lib/Core/Constants` – app_colors.dart, api_endpoints.dart
- `lib/data/api` – transaction_api.dart (HTTP fetch)
- `lib/data/models` – transaction_model.dart (API-shaped)
- `lib/data/repository` – transaction_repository.dart
- `lib/presentation/providers` – transaction_provider.dart, add_transaction_form_provider.dart
- `lib/presentation/screens` – transaction_screen.dart, add_transaction_screen.dart
- `lib/presentation/widgets` – transaction_list_item.dart

## Features

- **Transaction screen**: Fetches from API on load. Shows Total Balance, Total Income, Total Expense. List grouped by month. Refresh re-fetches API. FAB opens Add Transaction.
- **Add Transaction screen**: Form fields – Date, Transaction Type (Income/Expense), Category, Amount, Title, Message. Category list depends on type. “Other” shows extra text field. Save adds via Provider and navigates back; new transaction appears under correct month and type.
- **State**: Provider only (TransactionProvider, AddTransactionFormProvider). No setState.

## API

- URL: `https://cdn.shopify.com/s/files/1/0931/5614/7572/files/res.json`
- Response: `{ "status", "data": { "summary": { totalBalance, totalIncome, totalExpense }, "transactions": [...] } }`

## Design reference

- Figma: [SW-flutter-interview](https://www.figma.com/design/JshAihhnc9X8E8CcWEAlca/SW-flutter-interview?node-id=1-327)
