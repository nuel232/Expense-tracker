import 'package:expense_tracker/components/catergory_spending_bar.dart';
import 'package:expense_tracker/components/tab_item.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:expense_tracker/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  bool showPieChart = true;
  // Calculate category totals for a specific time period
  Map<String, double> calculateCategoryTotals(
    List<ExpenseDetails> expenses,
    String period,
  ) {
    final Map<String, double> totals = {};
    final DateTime now = DateTime.now();

    // Filter expenses based on time period
    List<ExpenseDetails> filteredExpenses = expenses.where((expense) {
      // Exclude income from category spending analysis
      if (expense.category == Category.income) return false;

      switch (period) {
        case 'weekly':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          final weekEnd = weekStart.add(Duration(days: 6));
          return expense.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
              expense.date.isBefore(weekEnd.add(Duration(days: 1)));

        case 'monthly':
          return expense.date.year == now.year &&
              expense.date.month == now.month;

        case 'yearly':
          return expense.date.year == now.year;

        default:
          return true;
      }
    }).toList();

    // Calculate totals for each category
    for (var expense in filteredExpenses) {
      final key = expense.category.label;
      totals[key] = (totals[key] ?? 0) + expense.amount;
    }

    return totals;
  }

  // Get time period display text
  String getPeriodDisplayText(String period) {
    final DateTime now = DateTime.now();
    switch (period) {
      case 'weekly':
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return 'This Week (${weekStart.day} - ${now.day})';
      case 'monthly':
        return 'This Month (${_getMonthName(now.month)} ${now.year})';
      case 'yearly':
        return 'This Year (${now.year})';
      default:
        return 'All Time';
    }
  }

  String _getMonthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  // Get category color
  Color getCategoryColor(String categoryName) {
    // Find the category enum by name and return its color
    try {
      final category = Category.values.firstWhere(
        (cat) => cat.label == categoryName,
      );
      return category.color;
    } catch (e) {
      // Return a default color if category not found
      return Colors.blue;
    }
  }

  // Build pie chart
  Widget buildPieChart(Map<String, double> categoryTotals) {
    if (categoryTotals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pie_chart, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No expenses to display',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final total = categoryTotals.values.reduce((a, b) => a + b);
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: [
        // Pie Chart
        Container(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(200, 200),
                painter: PieChartPainter(
                  data: categoryTotals,
                  getCategoryColor: getCategoryColor,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "₦${total.toStringAsFixed(0)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        // Legend
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 8,
              children: sortedEntries.map((entry) {
                final percentage = ((entry.value / total) * 100)
                    .toStringAsFixed(1);
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: getCategoryColor(entry.key),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "${entry.key} ($percentage%)",
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Build spending bars for a specific period
  Widget buildSpendingBars(Map<String, double> categoryTotals, String period) {
    if (categoryTotals.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No expenses for ${period.toLowerCase()} period',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final maxAmount = categoryTotals.values.reduce((a, b) => a > b ? a : b);
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // Sort by amount descending

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500.withOpacity(0.1),
              spreadRadius: 0.2,
              blurRadius: 0.2,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getPeriodDisplayText(period),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: sortedEntries.length,
                itemBuilder: (context, index) {
                  final entry = sortedEntries[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${((entry.value / maxAmount) * 100).toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        CategorySpendingBar(
                          category: entry.key,
                          amount: entry.value,
                          maxAmount: maxAmount,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.transparent,
          title: Text('Expense Statistics'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  tabs: [
                    TabItem(title: 'Weekly'),
                    TabItem(title: 'Monthly'),
                    TabItem(title: 'Yearly'),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: CircleAvatar(
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  icon: Icon(Icons.person),
                ),
              ),
            ),
          ],
        ),
        body: Consumer<ExpenseDatabase>(
          builder: (context, expenseDatabase, child) {
            final expenses = expenseDatabase.currentExpenses;

            return TabBarView(
              children: [
                // Weekly tab
                Column(
                  children: [
                    buildPieChart(calculateCategoryTotals(expenses, 'weekly')),
                    SizedBox(height: 20),
                    buildSpendingBars(
                      calculateCategoryTotals(expenses, 'weekly'),
                      'weekly',
                    ),
                  ],
                ),
                // Monthly tab
                Column(
                  children: [
                    buildPieChart(calculateCategoryTotals(expenses, 'monthly')),
                    SizedBox(height: 20),

                    buildSpendingBars(
                      calculateCategoryTotals(expenses, 'monthly'),
                      'monthly',
                    ),
                  ],
                ),
                // Yearly tab
                Column(
                  children: [
                    buildPieChart(calculateCategoryTotals(expenses, 'yearly')),
                    SizedBox(height: 20),

                    buildSpendingBars(
                      calculateCategoryTotals(expenses, 'yearly'),
                      'yearly',
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Custom Painter for Pie Chart
class PieChartPainter extends CustomPainter {
  final Map<String, double> data;
  final Color Function(String) getCategoryColor;

  PieChartPainter({required this.data, required this.getCategoryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final total = data.values.reduce((a, b) => a + b);

    double startAngle = -math.pi / 2; // Start from top

    for (final entry in data.entries) {
      final sweepAngle = (entry.value / total) * 2 * math.pi;

      final paint = Paint()
        ..color = getCategoryColor(entry.key)
        ..style = PaintingStyle.fill;

      // Draw pie slice
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center circle (donut effect)
    final centerPaint = Paint()
      ..color =
          Theme.of(
            canvas as BuildContext? ?? Colors.white as dynamic,
          ).colorScheme?.surface ??
          Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
