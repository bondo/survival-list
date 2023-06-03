import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:survival_list/home/home.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class ItemListTile extends StatelessWidget {
  const ItemListTile({
    required this.item,
    required this.viewerPerson,
    super.key,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
  });

  final Item item;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;
  final Person? viewerPerson;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;
    final avatar = Avatar(
      photo: (item.responsible ?? viewerPerson)?.pictureUrl,
    );

    final tile = ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Expanded(
            child: Text(
              item.title,
              maxLines: 1,
              style: !item.isCompleted
                  ? const TextStyle(overflow: TextOverflow.ellipsis)
                  : TextStyle(
                      color: captionColor,
                      decoration: TextDecoration.lineThrough,
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
          ),
        ],
      ),
      subtitle: item.endDate == null
          ? null
          : Row(
              children: [
                Expanded(
                  child: Text(
                    DateFormat.yMMMMEEEEd(l10n.localeName)
                        .format(item.endDate!),
                    maxLines: 1,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
      leading: Checkbox(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        value: item.isCompleted,
        onChanged: onToggleCompleted == null || !item.canToggle
            ? null
            : (value) => onToggleCompleted!(value!),
      ),
      trailing: onTap == null || !item.canUpdate
          ? Padding(
              padding: const EdgeInsets.only(right: 24),
              child: avatar,
            )
          : FittedBox(
              child: Row(
                children: [
                  avatar,
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
    );

    if (item.canDelete) {
      return Dismissible(
        key: Key('todoListTile_dismissible_${item.id}'),
        onDismissed: onDismissed,
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          color: theme.colorScheme.error,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(
            Icons.delete,
            color: Color(0xAAFFFFFF),
          ),
        ),
        child: tile,
      );
    } else {
      return tile;
    }
  }
}
