import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/display_group/display_group.dart';
import 'package:survival_list/groups/groups.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => GroupsBloc(
          survivalListRepository: context.read<SurvivalListRepository>(),
        )..add(const GroupsSubscriptionRequested()),
        child: const GroupsView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupsBloc, GroupsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == GroupsStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const GroupsView(),
    );
  }
}

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.groupsAppBarTitle),
        actions: const [
          GroupsOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GroupsBloc, GroupsState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == GroupsStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.groupsErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<GroupsBloc, GroupsState>(
          builder: (context, state) {
            if (state.groups.isEmpty) {
              if (state.status == GroupsStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != GroupsStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    l10n.groupsEmptyText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return ListView(
              children: [
                for (final group in state.groups)
                  GroupsListTile(
                    group: group,
                    onTap: () {
                      Navigator.of(context).push(
                        DisplayGroupPage.route(group: group),
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
