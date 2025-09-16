import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyNavBar extends StatelessWidget {
  Function(int)? onTabChange;
  MyNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: GNav(
        color: Colors.grey[500],
        activeColor: Colors.grey.shade700,
        tabActiveBorder: Border.all(color: Colors.white),
        tabBackgroundColor: Colors.grey.shade100,
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 10,
        onTabChange: (value) => onTabChange!(value),

        tabs: [
          GButton(icon: Icons.home, text: 'home'),
          GButton(icon: Icons.add, text: 'Expenses'),

          GButton(icon: Icons.shopping_bag, text: 'statistic'),
        ],
      ),
    );
  }
}
