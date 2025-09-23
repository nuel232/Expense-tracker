import 'package:expense_tracker/components/grouped_transactions.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    //Expense Database
    final expenseDatabase = context.watch<ExpenseDatabase>();
    List<ExpenseDetails> currentExpenses = expenseDatabase
        .currentExpenses
        .reversed
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text('Download', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          // color: Colors.grey.shade200,
          // border: Border.all(color: Colors.grey.shade400),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500.withOpacity(0.1),
              spreadRadius: 0.2,
              blurRadius: 0.2,
              offset: Offset(4, 4),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.primary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          borderRadius: BorderRadius.circular(12),
        ),

        child: ListView(
          children: [
            GroupedTransactions(
              expenses: currentExpenses,
              groupedByMonth: true,

              showDateTotals: true,
              emptyMessage: 'No recent transactions',
            ),
          ],
        ),
      ),
    );
  }
}
