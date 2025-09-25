import 'package:flutter/material.dart';

class MyInputWrapper extends StatelessWidget {
  final Widget? child;
  final String? labelText;

  const MyInputWrapper({super.key, this.child, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.secondary,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: child,
    );
  }
}
