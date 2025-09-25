import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:expense_tracker/util/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupedTransactions extends StatelessWidget {
  final List<ExpenseDetails> expenses;
  final bool showDateTotals;
  final int? maxDaysToShow; // Optional limit for dashboard
  final String? emptyMessage;
  final bool groupedByMonth;

  const GroupedTransactions({
    super.key,
    required this.expenses,
    this.showDateTotals = true,
    this.maxDaysToShow,
    this.emptyMessage = 'No transactions yet',
    this.groupedByMonth = false,
  });

  // Group expenses by date
  Map<String, List<ExpenseDetails>> groupExpenses(
    List<ExpenseDetails> expenses,
  ) {
    Map<String, List<ExpenseDetails>> grouped = {};

    for (var expense in expenses) {
      String dateKey = groupedByMonth
          ? DateFormat('yyyy-MM').format(expense.date)
          : DateFormat('yyyy-MM-dd').format(expense.date);

      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(expense);
    }

    // Sort each group by time (newest first within the day)
    grouped.forEach((key, value) {
      value.sort((a, b) => b.date.compareTo(a.date));
    });

    return grouped;
  }

  // Format date for display
  String formatDateForDisplay(String dateKey) {
    if (groupedByMonth) {
      // Convert yyyy-MM to "September 2025"
      DateTime monthDate = DateFormat('yyyy-MM').parse(dateKey);
      return DateFormat('MMM yyyy').format(monthDate);
    } else {
      // Original daily formatting
      DateTime date = DateTime.parse(dateKey);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(Duration(days: 1));
      DateTime expenseDate = DateTime(date.year, date.month, date.day);

      if (expenseDate == today) {
        return 'Today';
      } else if (expenseDate == yesterday) {
        return 'Yesterday';
      } else {
        return DateFormat('EEEE, MMM d, yyyy').format(date);
      }
    }
  }

  // Calculate total for a day
  double calculateDayTotal(List<ExpenseDetails> expenses) {
    return expenses.fold(
      0.0,
      (sum, expense) => expense.category == Category.income
          ? sum + expense.amount
          : sum - expense.amount,
    );
  }

  // Calculate income and expenses separately for a group (day OR month)
  Map<String, double> calculateGroupInOut(List<ExpenseDetails> expenses) {
    double income = 0.0;
    double expensesOut = 0.0;

    for (var expense in expenses) {
      if (expense.category == Category.income) {
        income += expense.amount;
      } else {
        expensesOut += expense.amount;
      }
    }

    return {
      "income": income,
      "expenses": expensesOut,
      "net": income - expensesOut, // optional net value
    };
  }

  @override
  Widget build(BuildContext context) {
    // Group expenses by date
    Map<String, List<ExpenseDetails>> groupedExpenses = groupExpenses(expenses);

    // Sort dates (newest first)
    List<String> sortedDates = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    // Apply limit if specified (for dashboard)
    if (maxDaysToShow != null && sortedDates.length > maxDaysToShow!) {
      sortedDates = sortedDates.take(maxDaysToShow!).toList();
    }

    return Column(
      children: sortedDates.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  emptyMessage!,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ]
          : sortedDates.map((dateKey) {
              List<ExpenseDetails> dayExpenses = groupedExpenses[dateKey]!;
              final totals = calculateGroupInOut(dayExpenses);
              double income = totals["income"]!;
              double expensesOut = totals["expenses"]!;
              double net = totals["net"]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date header with total (if enabled)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: sortedDates.first == dateKey
                          ? BorderRadius.circular(30)
                          : BorderRadius.zero,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDateForDisplay(dateKey),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (showDateTotals)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                "In: ₦${NumberFormat.decimalPattern().format(income)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "out: ₦${NumberFormat.decimalPattern().format(expensesOut)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  // Transactions for this day
                  ...dayExpenses.map(
                    (expense) => TransactionTile(
                      expenseDetails: expense,
                      subtitle: groupedByMonth
                          ? Text(
                              DateFormat('MMM d • h:mm a').format(expense.date),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            )
                          : null,
                    ),
                  ),
                  if (sortedDates.last != dateKey)
                    Divider(height: 1, color: Colors.grey.shade300),
                ],
              );
            }).toList(),
    );
  }
}
