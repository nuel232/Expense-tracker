import 'package:expense_tracker/models/category.dart';
import 'package:hive/hive.dart';

part 'expense_details.g.dart'; // 👈 required for Hive generator

@HiveType(typeId: 0)
class ExpenseDetails extends HiveObject {
  @HiveField(0)
  double amount;

  @HiveField(1)
  Category category;

  @HiveField(2)
  String? note;

  @HiveField(3)
  DateTime date;

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
