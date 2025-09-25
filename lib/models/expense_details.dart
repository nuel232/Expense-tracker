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
}
