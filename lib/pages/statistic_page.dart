import 'package:expense_tracker/pages/profile_page.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController NoteController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
        title: Text('Expense Statistics'),
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

      body: Container(
        child: Column(
          children: [
            Text('Amount'),
            TextField(controller: amountController),

            //Category
            Text('Category'),
            Container(),

            //date
            Text('Date'),
            Container(),

            //note
            Text('Note'),

            TextField(controller: NoteController),
          ],
        ),
      ),
    );
  }
}
