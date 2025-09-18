import 'package:flutter/material.dart';

class MyInputWrapper extends StatelessWidget {
  final Widget? child; // the inner widget (TextField, Dropdown, etc.)
  final String? labelText; // optional label

  const MyInputWrapper({super.key, this.child, this.labelText});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(12),
        ),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
      ),
      child: child,
    );
  }
}
