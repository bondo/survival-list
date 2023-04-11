import 'package:flutter/material.dart';
import 'package:survival_list/create_group/create_group.dart';
import 'package:survival_list/join_group/join_group.dart';
import 'package:survival_list/l10n/l10n.dart';

enum GroupsOption { create, join }

class GroupsOptionsButton extends StatelessWidget {
  const GroupsOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopupMenuButton<GroupsOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: l10n.groupsOptionsTooltip,
      onSelected: (options) {
        switch (options) {
          case GroupsOption.create:
            Navigator.of(context).push(CreateGroupPage.route());
            break;
          case GroupsOption.join:
            Navigator.of(context).push(JoinGroupPage.route());
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: GroupsOption.create,
            child: Text(l10n.groupsOptionsCreate),
          ),
          PopupMenuItem(
            value: GroupsOption.join,
            child: Text(l10n.groupsOptionsJoin),
          ),
        ];
      },
      icon: const Icon(Icons.add),
    );
  }
}
