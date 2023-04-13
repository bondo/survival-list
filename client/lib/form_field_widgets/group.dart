import 'package:flutter/material.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class GroupFormField extends StatelessWidget {
  const GroupFormField({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.label,
    super.key,
  });

  final Group? value;
  final List<Group>? options;
  final void Function(Group?) onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final empty = DropdownMenuItem<Group?>(
      child: Text(
        l10n.widgetGroupEmptyValueTitle,
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
    final items = options
        ?.map(
          (group) =>
              DropdownMenuItem<Group?>(value: group, child: Text(group.title)),
        )
        .toList();
    if (items != null && value != null) {
      items.insert(0, empty);
    }

    return DropdownButtonFormField<Group?>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        icon: const Icon(Icons.group),
        labelText: label,
      ),
    );
  }
}
