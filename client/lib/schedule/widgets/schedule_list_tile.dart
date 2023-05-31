import 'package:flutter/material.dart';
import 'package:survival_list/home/home.dart';
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
    final theme = Theme.of(context);
    final captionColor = theme.textTheme.bodySmall?.color;

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
      child: ListTile(
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            Avatar(
              photo: (item.responsible ?? viewerPerson)?.pictureUrl,
            ),
          ],
        ),
        // subtitle: Text(
        //   item.description,
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        // ),
        leading: Checkbox(
          shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          value: item.isCompleted,
          onChanged: onToggleCompleted == null
              ? null
              : (value) => onToggleCompleted!(value!),
        ),
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}
