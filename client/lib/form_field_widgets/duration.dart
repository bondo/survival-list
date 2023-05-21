import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:survival_list_repository/survival_list_repository.dart';

class DurationFormField extends StatelessWidget {
  DurationFormField({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
  })  : _daysController = TextEditingController(
          text: value.days.toString(),
        ),
        _hoursController = TextEditingController(
          text: value.hours.toString(),
        ),
        _minutesController = TextEditingController(
          text: value.minutes.toString(),
        );

  final TextEditingController _daysController;
  final TextEditingController _hoursController;
  final TextEditingController _minutesController;
  final SimpleDuration value;
  final void Function(SimpleDuration) onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _daysController,
          decoration: InputDecoration(
            icon: const Icon(Icons.watch),
            labelText: label,
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final days = int.tryParse(value, radix: 10) ?? 0;
            onChanged(this.value.copyWith(days: () => days));
          },
        ),
        TextField(
          controller: _hoursController,
          decoration: InputDecoration(
            icon: const Icon(Icons.watch),
            labelText: label,
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final hours = int.tryParse(value, radix: 10) ?? 0;
            onChanged(this.value.copyWith(hours: () => hours));
          },
        ),
        TextField(
          controller: _minutesController,
          decoration: InputDecoration(
            icon: const Icon(Icons.watch),
            labelText: label,
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            final minutes = int.tryParse(value, radix: 10) ?? 0;
            onChanged(this.value.copyWith(minutes: () => minutes));
          },
        )
      ],
    );
  }
}
