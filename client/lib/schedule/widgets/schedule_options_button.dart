import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/l10n/l10n.dart';
// import 'package:survival_list/schedule/schedule.dart';

@visibleForTesting
enum ScheduleOption { todo }

class ScheduleOptionsButton extends StatelessWidget {
  const ScheduleOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // final todos = context.select((ScheduleBloc bloc) => bloc.state.todos);
    // final hasItems = todos.isNotEmpty;
    // final completedItemsAmount = todos.where((item) => item.isCompleted).length;

    return PopupMenuButton<ScheduleOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: l10n.scheduleOptionsTooltip,
      // onSelected: (options) {
      //   switch (options) {
      //     case ScheduleOption.toggleAll:
      //       context
      //           .read<ScheduleBloc>()
      //           .add(const ScheduleToggleAllRequested());
      //       break;
      //     case ScheduleOption.clearCompleted:
      //       context
      //           .read<ScheduleBloc>()
      //           .add(const ScheduleClearCompletedRequested());
      //   }
      // },
      itemBuilder: (context) {
        return [
          // PopupMenuItem(
          //   value: ScheduleOption.toggleAll,
          //   enabled: hasItems,
          //   child: Text(
          //     completedItemsAmount == todos.length
          //         ? l10n.scheduleOptionsMarkAllIncomplete
          //         : l10n.scheduleOptionsMarkAllComplete,
          //   ),
          // ),
          // PopupMenuItem(
          //   value: ScheduleOption.clearCompleted,
          //   enabled: hasItems && completedItemsAmount > 0,
          //   child: Text(l10n.scheduleOptionsClearCompleted),
          // ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
