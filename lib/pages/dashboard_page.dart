import 'package:expense_tracker/components/grouped_transactions.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:expense_tracker/pages/history_page.dart';
import 'package:expense_tracker/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    //Expense Database
    final expenseDatabase = context.watch<ExpenseDatabase>();
    List<ExpenseDetails> currentExpenses = expenseDatabase
        .currentExpenses
        .reversed
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        title: Text('Expense tracker'),
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),

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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total balance',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),

                              Icon(Icons.remove_red_eye_outlined, size: 20),
                            ],
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Text('history'),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      Text(
                        '₦120,000',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //budget and Expense
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    margin: EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      // color: Colors.grey.shade200,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.tertiary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),

                      borderRadius: BorderRadius.circular(10),

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
                        Text("Budget", style: TextStyle(fontSize: 20)),
                        Text(
                          '₦30,000',
                          style: TextStyle(fontSize: 20, color: Colors.green),
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(width: 5),s
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    margin: EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      // color: Colors.grey.shade200,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.tertiary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),

                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),
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
                        Text("Expense", style: TextStyle(fontSize: 20)),
                        Text(
                          '₦40,000',
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30),

              //Recent Transactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Recent Transaction',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),

              //recent transactions
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
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
                constraints: BoxConstraints(
                  maxHeight: 350, // adjust to fit 5 tiles comfortably
                ),

                child: ListView(
                  children: [
                    GroupedTransactions(
                      expenses: currentExpenses,

                      showDateTotals: false,
                      emptyMessage: 'No recent transactions',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
