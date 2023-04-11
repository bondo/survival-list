import 'package:flutter/material.dart';
import 'package:survival_list/create_group/create_group.dart';
import 'package:survival_list/l10n/l10n.dart';

class GroupsCreateButton extends StatelessWidget {
  const GroupsCreateButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: l10n.displayGroupOptionsEditTooltip,
      onPressed: () {
        Navigator.of(context).push(
          CreateGroupPage.route(),
        );
      },
    );
  }
}
