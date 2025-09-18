import 'package:expense_tracker/components/my_input_wapper.dart';
import 'package:flutter/material.dart';

class MyDatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const MyDatePickerField({
    super.key,
    this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<MyDatePickerField> createState() => _MyDatePickerFieldState();
}

class _MyDatePickerFieldState extends State<MyDatePickerField> {
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickDate,
      child: MyInputWrapper(
        child: Text(
          _selectedDate == null
              ? "Select a date"
              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
        ),
      ),
    );
  }
}
