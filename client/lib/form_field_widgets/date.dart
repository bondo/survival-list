import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormField extends StatelessWidget {
  DateFormField({
    required DateTime? value,
    required String locale,
    required this.onChanged,
    required this.label,
    super.key,
    this.firstDate,
    this.lastDate,
  })  : _controller = TextEditingController(
          text:
              value == null ? '' : DateFormat.yMMMMEEEEd(locale).format(value),
        ),
        _value = value ?? firstDate ?? DateTime.now();

  final TextEditingController _controller;
  final DateTime _value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime?) onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        icon: const Icon(Icons.calendar_today),
        labelText: label,
      ),
      readOnly: true,
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: _value,
          firstDate: firstDate ?? DateTime(DateTime.now().year - 1),
          lastDate: lastDate ?? DateTime(2101),
        );
        onChanged(pickedDate);
      },
    );
  }
}
