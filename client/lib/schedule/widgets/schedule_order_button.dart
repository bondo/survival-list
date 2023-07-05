import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/schedule/schedule.dart';

class ScheduleOrderButton extends StatelessWidget {
  const ScheduleOrderButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final activeOrder = context.select((ScheduleBloc bloc) => bloc.state.order);

    return PopupMenuButton<ScheduleViewOrder>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeOrder,
      tooltip: l10n.scheduleOrderTooltip,
      onSelected: (order) {
        context.read<ScheduleBloc>().add(ScheduleOrderChanged(order));
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ScheduleViewOrder.byDate,
            child: Text(l10n.scheduleOrderByDate),
          ),
          PopupMenuItem(
            value: ScheduleViewOrder.byEstimate,
            child: Text(l10n.scheduleOrderByEstimate),
          ),
          PopupMenuItem(
            value: ScheduleViewOrder.byTitle,
            child: Text(l10n.scheduleOrderByTitle),
          ),
          PopupMenuItem(
            value: ScheduleViewOrder.byRandom,
            child: Text(l10n.scheduleOrderByRandom),
          ),
        ];
      },
      icon: const Icon(Icons.sort_rounded),
    );
  }
}
