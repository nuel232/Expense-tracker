import 'package:expense_tracker/components/my_input_wapper.dart';
import 'package:flutter/material.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;

  const MyTextfield({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return MyInputWrapper(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,

        decoration: InputDecoration(
          hintText: hintText, // 👈 stays as hint
          border: InputBorder.none,
        ),
      ),
    );
  }
}
