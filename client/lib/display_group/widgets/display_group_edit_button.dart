import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/display_group/display_group.dart';
import 'package:survival_list/edit_group/edit_group.dart';
import 'package:survival_list/l10n/l10n.dart';

class DisplayGroupEditButton extends StatelessWidget {
  const DisplayGroupEditButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<DisplayGroupBloc>().state;

    return IconButton(
      icon: const Icon(Icons.edit),
      tooltip: l10n.displayGroupOptionsEditTooltip,
      onPressed: () {
        Navigator.of(context).push(
          EditGroupPage.route(group: state.group),
        );
      },
    );
  }
}
