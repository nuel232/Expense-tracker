import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategorySpendingBar extends StatelessWidget {
  final String category;
  final double amount;
  final double maxAmount;

  const CategorySpendingBar({
    super.key,
    required this.category,
    required this.amount,
    required this.maxAmount,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: amount / maxAmount, // percent of bar filled
                minHeight: 15,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ),
          SizedBox(width: 10),
          // Amount
          Text(
            '₦${formatter.format(amount)}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
