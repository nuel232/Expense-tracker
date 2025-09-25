import 'package:expense_tracker/components/catergory_spending_bar.dart';
import 'package:expense_tracker/components/pie_chart_painter.dart';
import 'package:expense_tracker/components/tab_item.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:expense_tracker/pages/profile_page.dart';
import 'package:expense_tracker/util/finance_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Import the enhanced GroupedTransactions
import 'package:expense_tracker/components/grouped_transactions.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  // Create a NumberFormat instance for thousands separator
  final formatter = NumberFormat.decimalPattern();

  // Get category color
  Color getCategoryColor(String categoryName) {
    try {
      final category = Category.values.firstWhere(
        (cat) => cat.label == categoryName,
      );
      return category.color;
    } catch (e) {
      return Colors.blue;
    }
  }

  // Build pie chart
  Widget buildPieChart(Map<String, double> categoryTotals) {
    if (categoryTotals.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.pie_chart, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No expenses to display',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              Text(
                'Only income recorded',
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ],
          ),
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
                  backgroundColor: Theme.of(context).colorScheme.surface,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "₦${formatter.format(total)}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
  Widget buildSpendingBars(
    Map<String, double> categoryTotals,
    GroupingPeriod period,
  ) {
    if (categoryTotals.isEmpty) {
      return Container(
        height: 200, // Fixed height instead of Expanded
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No expenses for ${FinanceUtils.getPeriodDisplayText(period).toLowerCase()}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    final maxAmount = categoryTotals.values.reduce((a, b) => a > b ? a : b);
    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
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
        mainAxisSize: MainAxisSize.min, // Important: Don't expand to fill
        children: [
          Text(
            FinanceUtils.getPeriodDisplayText(period),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // Use Column instead of Expanded ListView for better scrolling
          ...sortedEntries
              .map(
                (entry) => Padding(
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
                ),
              )
              .toList(),
        ],
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
            final allExpenses = expenseDatabase.currentExpenses;

            return TabBarView(
              children: [
                // Weekly tab
                _buildPeriodView(allExpenses, GroupingPeriod.weekly),
                // Monthly tab
                _buildPeriodView(allExpenses, GroupingPeriod.monthly),
                // Yearly tab
                _buildPeriodView(allExpenses, GroupingPeriod.yearly),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPeriodView(
    List<ExpenseDetails> allExpenses,
    GroupingPeriod period,
  ) {
    // Use FinanceUtils instead of local methods
    final filteredExpenses = FinanceUtils.getExpensesForPeriod(
      allExpenses,
      period,
    );
    final categoryTotals = FinanceUtils.calculateCategoryTotals(
      filteredExpenses,
    );
    final periodFinancials = FinanceUtils.calculatePeriodFinancials(
      filteredExpenses,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          // Financial Summary Card
          Container(
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
              children: [
                Text(
                  FinanceUtils.getPeriodDisplayText(period),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₦${formatter.format(periodFinancials["income"]!)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Expenses',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₦${formatter.format(periodFinancials["expenses"]!)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Net',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₦${formatter.format(periodFinancials["net"]!)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: periodFinancials["net"]! >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          buildPieChart(categoryTotals),
          SizedBox(height: 20),
          buildSpendingBars(categoryTotals, period),
          SizedBox(height: 20), // Add bottom padding
        ],
      ),
    );
  }
}
