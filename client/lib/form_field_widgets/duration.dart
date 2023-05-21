import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class DurationFormField extends StatefulWidget {
  const DurationFormField({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final SimpleDuration initialValue;
  final void Function(SimpleDuration) onChanged;

  @override
  State<DurationFormField> createState() => _DurationFormFieldState();
}

class _DurationFormFieldState extends State<DurationFormField> {
  late SimpleDuration _value;
  late TextEditingController _daysController;
  late TextEditingController _hoursController;
  late TextEditingController _minutesController;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _daysController = TextEditingController(
      text: (_value.days > 0 ? _value.days.toString() : ''),
    );
    _hoursController = TextEditingController(
      text: (_value.hours > 0 ? _value.hours.toString() : ''),
    );
    _minutesController = TextEditingController(
      text: (_value.minutes > 0 ? _value.minutes.toString() : ''),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _daysController.dispose();
    _hoursController.dispose();
    _minutesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        Expanded(
          flex: 15,
          child: TextField(
            controller: _daysController,
            decoration: InputDecoration(
              icon: const Icon(Icons.watch),
              labelText: l10n.widgetDurationDaysLabel,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            onChanged: (text) {
              final days = int.tryParse(text, radix: 10) ?? 0;
              setState(() {
                _value = _value.copyWith(days: () => days);
              });
              widget.onChanged(_value);
            },
          ),
        ),
        Expanded(
          flex: 11,
          child: TextField(
            controller: _hoursController,
            decoration: InputDecoration(
              labelText: l10n.widgetDurationHoursLabel,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            onChanged: (text) {
              final hours = int.tryParse(text, radix: 10) ?? 0;
              setState(() {
                _value = _value.copyWith(hours: () => hours);
              });
              widget.onChanged(_value);
            },
          ),
        ),
        Expanded(
          flex: 11,
          child: TextField(
            controller: _minutesController,
            decoration: InputDecoration(
              labelText: l10n.widgetDurationMinutesLabel,
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            keyboardType: TextInputType.number,
            onChanged: (text) {
              final minutes = int.tryParse(text, radix: 10) ?? 0;
              setState(() {
                _value = _value.copyWith(minutes: () => minutes);
              });
              widget.onChanged(_value);
            },
          ),
        )
      ],
    );
  }
}
