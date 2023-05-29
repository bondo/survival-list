import 'package:flutter/material.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class RecurrenceKindFormField extends StatelessWidget {
  const RecurrenceKindFormField({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
  });

  final RecurrenceKind value;
  final void Function(RecurrenceKind) onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DropdownButtonFormField<RecurrenceKind>(
      value: value,
      items: RecurrenceKind.values
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                switch (e) {
                  RecurrenceKind.none => l10n.widgetRecurrenceKindNever,
                  RecurrenceKind.checked => l10n.widgetRecurrenceKindChecked,
                  RecurrenceKind.every => l10n.widgetRecurrenceKindEvery
                },
              ),
            ),
          )
          .toList(),
      onChanged: (RecurrenceKind? value) {
        if (value == null) {
          return;
        }
        onChanged(value);
      },
      decoration: InputDecoration(
        icon: const Icon(Icons.replay),
        labelText: label,
      ),
    );
  }
}
