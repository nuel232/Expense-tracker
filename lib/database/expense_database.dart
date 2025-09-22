import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expense_details.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ExpenseDatabase extends ChangeNotifier {
  static late Box<ExpenseDetails> _expenseBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseDetailsAdapter());
    Hive.registerAdapter(CategoryAdapter());
    _expenseBox = await Hive.openBox<ExpenseDetails>('Expense');
  }

  //Get current Expenses
  List<ExpenseDetails> get currentExpenses => _expenseBox.values.toList();

  //Create
  Future<void> addExpenses(ExpenseDetails expense) async {
    await _expenseBox.add(expense);
    notifyListeners();
  }

  //Delete
  Future<void> deleteExpenses(int index) async {
    await _expenseBox.deleteAt(index);
    notifyListeners();
  }

  //helper to get note index
  int getNoteIndex(ExpenseDetails expense) {
    return _expenseBox.values.toList().indexOf(expense);
  }
}
