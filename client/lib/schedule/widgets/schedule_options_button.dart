import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/groups/groups.dart';
import 'package:survival_list/home/home.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/schedule/schedule.dart';

@visibleForTesting
enum ScheduleOption { logOut, groups }

class ScheduleOptionsButton extends StatelessWidget {
  const ScheduleOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final userPhotoUrl =
        context.select((ScheduleBloc bloc) => bloc.state.userPhotoUrl);

    return PopupMenuButton<ScheduleOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      tooltip: l10n.scheduleOptionsTooltip,
      onSelected: (options) {
        switch (options) {
          case ScheduleOption.groups:
            Navigator.of(context).push(GroupsPage.route());
            break;
          case ScheduleOption.logOut:
            context.read<ScheduleBloc>().add(const ScheduleLogoutRequested());
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ScheduleOption.groups,
            child: Text(l10n.scheduleOptionsGroups),
          ),
          PopupMenuItem(
            value: ScheduleOption.logOut,
            child: Text(l10n.scheduleOptionsLogOut),
          ),
        ];
      },
      icon: Avatar(photo: userPhotoUrl),
    );
  }
}
