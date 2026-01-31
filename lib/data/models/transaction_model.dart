class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.amount,
    required this.date,
  });

  final String id;
  final String type;
  final String title;
  final String message;
  final double amount;
  final DateTime date;

  bool get isIncome => type == 'income';

  String get formattedAmount => isIncome
      ? '+${amount.toStringAsFixed(2)}'
      : '-${amount.toStringAsFixed(2)}';

  String get timeString =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  String get dateString => '${_monthShort(date.month)} ${date.day}';

  String get monthKey =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  static String _monthShort(int month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return names[month - 1];
  }

  static const List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final dateStr = json['date'] as String? ?? '';
    DateTime parsed = DateTime.now();
    if (dateStr.isNotEmpty) {
      parsed = DateTime.tryParse(dateStr) ?? parsed;
    }
    return TransactionModel(
      id: json['id'] as String? ?? '',
      type: (json['type'] as String? ?? 'expense').toLowerCase(),
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      date: parsed,
    );
  }
}
