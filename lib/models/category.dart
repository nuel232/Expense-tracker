import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Category {
  food,
  bills,
  transport,
  shopping,
  entertainment,
  health,
  income,
  other,
}

extension CategoryX on Category {
  String get label {
    switch (this) {
      case Category.food:
        return 'Food';
      case Category.bills:
        return 'Bills';
      case Category.transport:
        return 'Transport';
      case Category.shopping:
        return 'Shopping';
      case Category.entertainment:
        return 'Entertainment';
      case Category.health:
        return 'Health';
      case Category.income:
        return 'Income';
      case Category.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case Category.food:
        return Icons.fastfood; // or FontAwesomeIcons.utensils
      case Category.bills:
        return Icons.receipt_long;
      case Category.transport:
        return Icons.directions_car;
      case Category.shopping:
        return Icons.shopping_bag;
      case Category.entertainment:
        return Icons.movie;
      case Category.health:
        return Icons.healing;
      case Category.income:
        return Icons.attach_money;
      case Category.other:
        return Icons.category;
    }
  }

  Color get color {
    switch (this) {
      case Category.income:
        return Colors.green;
      case Category.food:
        return Colors.orange;
      case Category.bills:
        return Colors.blueGrey;
      default:
        return Colors.blue;
    }
  }
}
