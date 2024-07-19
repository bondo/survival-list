import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/edit_item/bloc/edit_item_bloc.dart';
import 'package:survival_list/l10n/l10n.dart';

class EditItemDeleteButton extends StatelessWidget {
  const EditItemDeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bloc = context.read<EditItemBloc>();

    if (!bloc.state.item.canDelete) {
      return const SizedBox.shrink();
    }

    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: l10n.editItemOptionsDeleteTooltip,
      onPressed: () async {
        final navigator = Navigator.of(context);
        final isConfirmed = await showDialog<bool>(
          context: context,
          // Back button handling doesn't work properly when using root navigator
          useRootNavigator: false,
          builder: (_) => PopScope(
            child: AlertDialog(
              title: Text(l10n.editItemOptionsDeleteDialogTitle),
              content: Text(
                l10n.editItemOptionsDeleteDialogContent(
                  bloc.state.item.title,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(l10n.editItemOptionsDeleteDialogCancel),
                  onPressed: () => navigator.pop(false),
                ),
                TextButton(
                  child: Text(l10n.editItemOptionsDeleteDialogConfirm),
                  onPressed: () => navigator.pop(true),
                ),
              ],
            ),
            onPopInvoked: (bool didPop) async {
              if (didPop) {
                return;
              }
              navigator.pop(false);
            },
          ),
        );
        if (isConfirmed ?? false) {
          bloc.add(const DeleteItem());
          navigator.pop();
        }
      },
    );
  }
}
