import 'package:expense_tracker/components/my_date_picker_field.dart';
import 'package:expense_tracker/components/my_dropdown_menu.dart';
import 'package:expense_tracker/components/my_textfield.dart';
import 'package:expense_tracker/pages/profile_page.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatefulWidget {
  ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  TextEditingController amountController = TextEditingController();

  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        title: Text('Add Expense'),
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

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(23.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500.withOpacity(0.3),
                  spreadRadius: 0.5,
                  blurRadius: 0.5,
                  offset: Offset(4, 4),
                ),
              ],
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.primary,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 35,
                left: 25,
                right: 25,
                bottom: 30,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount', style: TextStyle(fontSize: 18)),
                    MyTextfield(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),

                    Text('Category', style: TextStyle(fontSize: 18)),
                    MyDropdownMenu(),
                    SizedBox(height: 20),

                    Text('Date', style: TextStyle(fontSize: 18)),
                    MyDatePickerField(
                      onDateSelected: (date) {
                        print("Picked date: $date");
                      },
                    ),
                    SizedBox(height: 20),

                    Text('Note', style: TextStyle(fontSize: 18)),
                    MyTextfield(
                      controller: noteController,
                      hintText: 'Optional',
                    ),

                    SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Center(
                          child: Text(
                            'save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
