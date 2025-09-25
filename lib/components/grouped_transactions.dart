import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:expense_tracker/util/transaction_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum GroupingPeriod { daily, weekly, monthly, yearly }

class GroupedTransactions extends StatelessWidget {
  final List<ExpenseDetails> expenses;
  final bool showDateTotals;
  final int? maxDaysToShow; // Optional limit for dashboard
  final String? emptyMessage;
  final GroupingPeriod groupingPeriod;

  const GroupedTransactions({
    super.key,
    required this.expenses,
    this.showDateTotals = true,
    this.maxDaysToShow,
    this.emptyMessage = 'No transactions yet',
    this.groupingPeriod = GroupingPeriod.daily,
  });

  // Group expenses by the specified period
  Map<String, List<ExpenseDetails>> groupExpenses(
    List<ExpenseDetails> expenses,
  ) {
    Map<String, List<ExpenseDetails>> grouped = {};

    for (var expense in expenses) {
      String dateKey;

      switch (groupingPeriod) {
        case GroupingPeriod.daily:
          dateKey = DateFormat('yyyy-MM-dd').format(expense.date);
          break;
        case GroupingPeriod.weekly:
          // Get the start of the week (Monday)
          DateTime startOfWeek = expense.date.subtract(
            Duration(days: expense.date.weekday - 1),
          );
          dateKey = 'week-${DateFormat('yyyy-MM-dd').format(startOfWeek)}';
          break;
        case GroupingPeriod.monthly:
          dateKey = DateFormat('yyyy-MM').format(expense.date);
          break;
        case GroupingPeriod.yearly:
          dateKey = DateFormat('yyyy').format(expense.date);
          break;
      }

      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(expense);
    }

    // Sort each group by time (newest first within the group)
    grouped.forEach((key, value) {
      value.sort((a, b) => b.date.compareTo(a.date));
    });

    return grouped;
  }

  // Format date for display based on grouping period
  String formatDateForDisplay(String dateKey) {
    switch (groupingPeriod) {
      case GroupingPeriod.daily:
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

      case GroupingPeriod.weekly:
        // Extract the date from the week key
        String weekStartStr = dateKey.replaceFirst('week-', '');
        DateTime weekStart = DateTime.parse(weekStartStr);
        DateTime weekEnd = weekStart.add(Duration(days: 6));

        return 'Week of ${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d, yyyy').format(weekEnd)}';

      case GroupingPeriod.monthly:
        DateTime monthDate = DateFormat('yyyy-MM').parse(dateKey);
        return DateFormat('MMMM yyyy').format(monthDate);

      case GroupingPeriod.yearly:
        return ' $dateKey';
    }
  }

  // Calculate income and expenses separately for a group
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
      "net": income - expensesOut,
    };
  }

  // Calculate category totals for the current grouping
  Map<String, double> calculateCategoryTotals(List<ExpenseDetails> expenses) {
    final Map<String, double> totals = {};

    for (var expense in expenses) {
      // Exclude income from category spending analysis
      if (expense.category == Category.income) continue;

      final key = expense.category.label;
      totals[key] = (totals[key] ?? 0) + expense.amount;
    }

    return totals;
  }

  // Filter expenses by current period (for weekly, monthly, yearly views)
  List<ExpenseDetails> getFilteredExpensesForCurrentPeriod(
    List<ExpenseDetails> expenses,
  ) {
    final DateTime now = DateTime.now();

    return expenses.where((expense) {
      switch (groupingPeriod) {
        case GroupingPeriod.weekly:
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(Duration(days: 6));
          return expense.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
              expense.date.isBefore(weekEnd.add(Duration(days: 1)));

        case GroupingPeriod.monthly:
          return expense.date.year == now.year &&
              expense.date.month == now.month;

        case GroupingPeriod.yearly:
          return expense.date.year == now.year;

        case GroupingPeriod.daily:
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Group expenses by the specified period
    Map<String, List<ExpenseDetails>> groupedExpenses = groupExpenses(expenses);

    // Sort groups (newest first)
    List<String> sortedGroups = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    // Apply limit if specified (for dashboard)
    if (maxDaysToShow != null && sortedGroups.length > maxDaysToShow!) {
      sortedGroups = sortedGroups.take(maxDaysToShow!).toList();
    }

    return Column(
      children: sortedGroups.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  emptyMessage!,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
            ]
          : sortedGroups.map((groupKey) {
              List<ExpenseDetails> groupExpenses = groupedExpenses[groupKey]!;
              final totals = calculateGroupInOut(groupExpenses);
              double income = totals["income"]!;
              double expensesOut = totals["expenses"]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group header with total (if enabled)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: sortedGroups.first == groupKey
                          ? BorderRadius.circular(30)
                          : BorderRadius.zero,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatDateForDisplay(groupKey),
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
                                "Out: ₦${NumberFormat.decimalPattern().format(expensesOut)}",
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
                  // Transactions for this group
                  ...groupExpenses.map(
                    (expense) => TransactionTile(
                      expenseDetails: expense,
                      subtitle: _getSubtitleForTransaction(expense),
                    ),
                  ),
                  if (sortedGroups.last != groupKey)
                    Divider(height: 1, color: Colors.grey.shade300),
                ],
              );
            }).toList(),
    );
  }

  // Get appropriate subtitle based on grouping period
  Widget? _getSubtitleForTransaction(ExpenseDetails expense) {
    switch (groupingPeriod) {
      case GroupingPeriod.daily:
        return null; // No subtitle needed for daily grouping
      case GroupingPeriod.weekly:
      case GroupingPeriod.monthly:
        return Text(
          DateFormat('MMM d • h:mm a').format(expense.date),
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        );
      case GroupingPeriod.yearly:
        return Text(
          DateFormat('MMM d, yyyy • h:mm a').format(expense.date),
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        );
    }
  }
}
