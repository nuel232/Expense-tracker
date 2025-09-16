import 'package:flutter/foundation.dart';

class ExpenseDetails {
  final double amount;
  final Category category;
  final String? note;
  final DateTime date;

  ExpenseDetails({
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toMap() => {
    'category': category.name, // save string name OR category.index
    'amount': amount,
    'date': date.toIso8601String(),
    'note': note,
  };

  static ExpenseDetails fromMap(Map m) => ExpenseDetails(
    category: Category.values.firstWhere((e) => e.name == m['category']),
    amount: (m['amount'] as num).toDouble(),
    date: DateTime.parse(m['date'] as String),
    note: m['note'] as String?,
  );
}
