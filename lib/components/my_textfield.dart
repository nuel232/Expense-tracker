import 'package:expense_tracker/components/my_input_wapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? prefixText;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;

  const MyTextfield({
    super.key,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.prefixText,
    this.style,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return MyInputWrapper(
      child: TextField(
        style: style,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,

        decoration: InputDecoration(
          prefixText: prefixText,
          prefixStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),

          border: InputBorder.none,
        ),
      ),
    );
  }
}
