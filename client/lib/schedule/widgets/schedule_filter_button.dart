import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/schedule/schedule.dart';

class ScheduleFilterButton extends StatelessWidget {
  const ScheduleFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeFilter =
        context.select((ScheduleBloc bloc) => bloc.state.filter);

    return PopupMenuButton<ScheduleViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      tooltip: l10n.scheduleFilterTooltip,
      onSelected: (filter) {
        context.read<ScheduleBloc>().add(ScheduleFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ScheduleViewFilter.all,
            child: Text(l10n.scheduleFilterAll),
          ),
          PopupMenuItem(
            value: ScheduleViewFilter.unchecked,
            child: Text(l10n.scheduleFilterUnchecked),
          ),
          PopupMenuItem(
            value: ScheduleViewFilter.responsible,
            child: Text(l10n.scheduleFilterResponsible),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
