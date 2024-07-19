import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/display_group/display_group.dart';
import 'package:survival_list/l10n/l10n.dart';

class DisplayGroupLeaveButton extends StatelessWidget {
  const DisplayGroupLeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return IconButton(
      icon: const Icon(Icons.logout),
      tooltip: l10n.displayGroupOptionsLeaveTooltip,
      onPressed: () async {
        final navigator = Navigator.of(context);
        final bloc = context.read<DisplayGroupBloc>();
        final isConfirmed = await showDialog<bool>(
          context: context,
          // Back button handling doesn't work properly when using root navigator
          useRootNavigator: false,
          builder: (_) => PopScope(
            child: AlertDialog(
              title: Text(l10n.displayGroupOptionsLeaveDialogTitle),
              content: Text(
                l10n.displayGroupOptionsLeaveDialogContent(
                  bloc.state.group.title,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(l10n.displayGroupOptionsLeaveDialogCancel),
                  onPressed: () => navigator.pop(false),
                ),
                TextButton(
                  child: Text(l10n.displayGroupOptionsLeaveDialogConfirm),
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
          bloc.add(const LeaveGroup());
          navigator.pop();
        }
      },
    );
  }
}
