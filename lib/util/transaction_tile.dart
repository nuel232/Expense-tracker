import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final ExpenseDetails expenseDetails;
  final Widget? subtitle;
  const TransactionTile({
    super.key,
    required this.expenseDetails,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    // Create a NumberFormat instance for thousands separator
    final formatter = NumberFormat.decimalPattern();
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: expenseDetails.category.color.withOpacity(0.2),
        child: Icon(
          expenseDetails.category.icon,
          color: expenseDetails.category.color,
        ),
      ),
      title: Text(
        expenseDetails.category.label,
        style: TextStyle(fontSize: 17),
      ),
      subtitle: subtitle,
      trailing: Text(
        '₦${formatter.format(expenseDetails.amount)}',
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
