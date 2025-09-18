import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:flutter/material.dart';

class TransactionTile extends StatelessWidget {
  final ExpenseDetails expenseDetails;
  const TransactionTile({super.key, required this.expenseDetails});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        expenseDetails.category.icon,
        color: expenseDetails.category.color,
      ),
      title: Text(
        expenseDetails.category.label,
        style: TextStyle(fontSize: 17),
      ),
      trailing: Text(
        '₦${expenseDetails.amount.toStringAsFixed(0)}',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: expenseDetails.category == Category.income
              ? Colors.green
              : Colors.red,
        ),
      ),
    );
  }
}
