import 'package:expense_tracker/models/expense_details.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/components/grouped_transactions.dart';

class FinanceUtils {
  // Filter expenses by period
  static List<ExpenseDetails> getExpensesForPeriod(
    List<ExpenseDetails> expenses,
    GroupingPeriod period,
  ) {
    final DateTime now = DateTime.now();

    return expenses.where((expense) {
      switch (period) {
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

  // Calculate income, expenses, and net
  static Map<String, double> calculatePeriodFinancials(
    List<ExpenseDetails> expenses,
  ) {
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
}
