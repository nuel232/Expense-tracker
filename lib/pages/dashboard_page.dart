import 'package:expense_tracker/pages/profile_page.dart';
import 'package:expense_tracker/util/transaction_tile.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade400),

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

                          Row(
                            children: [
                              Text('history'),
                              Icon(Icons.arrow_forward_ios_outlined, size: 15),
                            ],
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
                      color: Colors.grey.shade200,

                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),

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
                      color: Colors.grey.shade200,

                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
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

              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: Border.all(color: Colors.grey.shade400),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500.withOpacity(0.1),
                      spreadRadius: 0.2,
                      blurRadius: 0.2,
                      offset: Offset(4, 4),
                    ),
                  ],

                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TransactionTile(),
                    TransactionTile(),
                    TransactionTile(),
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
