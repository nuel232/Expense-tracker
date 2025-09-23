import 'package:expense_tracker/components/tab_item.dart';
import 'package:expense_tracker/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class StatisticPage extends StatelessWidget {
  const StatisticPage({super.key});

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
                    TabItem(title: 'weekly'),
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
        body: TabBarView(
          children: [
            Center(child: Text('weekly')),
            Center(child: Text('Monthly')),
            Center(child: Text('Yearly')),
          ],
        ),
      ),
    );
  }
}
