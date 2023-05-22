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
        DurationComponent(
          icon: const Icon(Icons.watch),
          flex: 15,
          controller: _daysController,
          label: l10n.widgetDurationDaysLabel,
          onChanged: (days) {
            setState(() {
              _value = _value.copyWith(days: () => days);
            });
            widget.onChanged(_value);
          },
        ),
        DurationComponent(
          flex: 11,
          controller: _hoursController,
          label: l10n.widgetDurationHoursLabel,
          onChanged: (hours) {
            setState(() {
              _value = _value.copyWith(hours: () => hours);
            });
            widget.onChanged(_value);
          },
        ),
        DurationComponent(
          flex: 11,
          controller: _minutesController,
          label: l10n.widgetDurationMinutesLabel,
          onChanged: (minutes) {
            setState(() {
              _value = _value.copyWith(minutes: () => minutes);
            });
            widget.onChanged(_value);
          },
        ),
      ],
    );
  }
}

class DurationComponent extends StatelessWidget {
  const DurationComponent({
    required this.controller,
    required this.label,
    required this.onChanged,
    required this.flex,
    this.icon,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final void Function(int) onChanged;
  final Widget? icon;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: icon,
          labelText: label,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        keyboardType: TextInputType.number,
        onChanged: (text) => onChanged(int.tryParse(text, radix: 10) ?? 0),
      ),
    );
  }
}
