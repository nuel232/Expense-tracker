import 'package:expense_tracker/components/my_input_wapper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class MyDropdownMenu extends StatefulWidget {
  const MyDropdownMenu({super.key});

  @override
  State<MyDropdownMenu> createState() => _MyDropdownMenuState();
}

class _MyDropdownMenuState extends State<MyDropdownMenu> {
  Category? _selectedCategory = Category.food;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyInputWrapper(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              value: _selectedCategory,
              isExpanded: true,
              items: Category.values.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Icon(c.icon, size: 18, color: c.color),
                      const SizedBox(width: 8),
                      Text(c.label),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (c) => setState(() => _selectedCategory = c),
            ),
          ),
        ),
      ],
    );
  }
}
