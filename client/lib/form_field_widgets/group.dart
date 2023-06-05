import 'package:flutter/material.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class GroupFormField extends StatelessWidget {
  const GroupFormField({
    required this.value,
    required this.options,
    required this.onChanged,
    required this.label,
    required this.viewerPerson,
    super.key,
  });

  final Group? value;
  final List<Group>? options;
  final void Function(Group?) onChanged;
  final String label;
  final Person? viewerPerson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final items = ((options?.isEmpty ?? true) && value != null
            ? [value!]
            : options)
        ?.map(
          (group) =>
              DropdownMenuItem<Group?>(value: group, child: Text(group.title)),
        )
        .toList();

    if (items != null) {
      items.insert(
        0,
        DropdownMenuItem<Group?>(
          child: Text(
            viewerPerson?.name ?? '',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return DropdownButtonFormField<Group?>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        icon: const Icon(Icons.group),
        labelText: label,
        helperText: l10n.widgetGroupHelperText,
      ),
    );
  }
}
