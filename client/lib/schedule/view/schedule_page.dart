import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/edit_item/view/edit_item_page.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list/schedule/schedule.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
        survivalListRepository: context.read<SurvivalListRepository>(),
      )..add(const ScheduleSubscriptionRequested()),
      child: const ScheduleView(),
    );
  }
}

class ScheduleView extends StatelessWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scheduleAppBarTitle),
        actions: const [
          ScheduleFilterButton(),
          ScheduleOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ScheduleBloc, ScheduleState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ScheduleStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.scheduleErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<ScheduleBloc, ScheduleState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedItem != current.lastDeletedItem &&
                current.lastDeletedItem != null,
            listener: (context, state) {
              final deletedItem = state.lastDeletedItem!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.scheduleItemDeletedSnackbarText(
                        deletedItem.title,
                      ),
                    ),
                    action: SnackBarAction(
                      label: l10n.scheduleUndoDeletionButtonText,
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<ScheduleBloc>()
                            .add(const ScheduleUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<ScheduleBloc, ScheduleState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == ScheduleStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != ScheduleStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    l10n.scheduleEmptyText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return ListView(
              children: [
                for (final item in state.filteredItems)
                  ItemListTile(
                    item: item,
                    onToggleCompleted: (isCompleted) {
                      context.read<ScheduleBloc>().add(
                            ScheduleItemCompletionToggled(
                              item: item,
                              isCompleted: isCompleted,
                            ),
                          );
                    },
                    onDismissed: (_) {
                      context
                          .read<ScheduleBloc>()
                          .add(ScheduleItemDeleted(item));
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        EditItemPage.route(item: item),
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
