import 'package:flutter/material.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class GroupsListTile extends StatelessWidget {
  const GroupsListTile({
    required this.group,
    super.key,
    this.onTap,
  });

  final Group group;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              group.title,
              maxLines: 1,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
    );
  }
}
