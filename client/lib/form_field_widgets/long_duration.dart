import 'package:flutter/material.dart';
import 'package:survival_list/form_field_widgets/duration_component.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class LongDurationFormField extends StatefulWidget {
  const LongDurationFormField({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final LongDuration initialValue;
  final void Function(LongDuration) onChanged;

  @override
  State<LongDurationFormField> createState() => _LongDurationFormFieldState();
}

class _LongDurationFormFieldState extends State<LongDurationFormField> {
  late LongDuration _value;
  late TextEditingController _monthsController;
  late TextEditingController _daysController;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _monthsController = TextEditingController(
      text: (_value.months > 0 ? _value.months.toString() : ''),
    );
    _daysController = TextEditingController(
      text: (_value.days > 0 ? _value.days.toString() : ''),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _monthsController.dispose();
    _daysController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        DurationComponent(
          icon: const Icon(Icons.event_repeat),
          flex: 13,
          controller: _monthsController,
          label: l10n.widgetDurationMonthsLabel,
          onChanged: (months) {
            setState(() {
              _value = _value.copyWith(months: () => months);
            });
            widget.onChanged(_value);
          },
        ),
        DurationComponent(
          flex: 11,
          controller: _daysController,
          label: l10n.widgetDurationDaysLabel,
          onChanged: (days) {
            setState(() {
              _value = _value.copyWith(days: () => days);
            });
            widget.onChanged(_value);
          },
        ),
      ],
    );
  }
}
