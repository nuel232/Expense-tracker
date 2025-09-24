import 'package:expense_tracker/components/my_nav_bar.dart';
import 'package:expense_tracker/pages/dashboard_page.dart';
import 'package:expense_tracker/pages/expense_page.dart';
import 'package:expense_tracker/pages/statistic_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //this is to control the bottom bar
  int _selectedIndex = 0;

  //this method will update our index
  //when the user taps on the navbar
  void navigateButtomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    //home page
    DashboardPage(),

    //add
    ExpensePage(),

    //statistic page
    StatisticPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyNavBar(
        onTabChange: (index) => navigateButtomBar(index),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: _pages[_selectedIndex],
    );
  }
}
