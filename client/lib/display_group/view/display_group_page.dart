import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/display_group/display_group.dart';
import 'package:survival_list/invite_group/invite_group.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class DisplayGroupPage extends StatelessWidget {
  const DisplayGroupPage({super.key});

  static Route<void> route({required Group group}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => DisplayGroupBloc(
          survivalListRepository: context.read<SurvivalListRepository>(),
          group: group,
        )..add(const DisplayGroupSubscriptionRequested()),
        child: const DisplayGroupView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DisplayGroupBloc, DisplayGroupState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == DisplayGroupStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const DisplayGroupView(),
    );
  }
}

class DisplayGroupView extends StatelessWidget {
  const DisplayGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<DisplayGroupBloc>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.group.title),
        actions: const [
          DisplayGroupEditButton(),
          DisplayGroupLeaveButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(InviteGroupPage.route(group: state.group)),
        child: const Icon(Icons.qr_code),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: MultiBlocListener(
        listeners: [
          BlocListener<DisplayGroupBloc, DisplayGroupState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == DisplayGroupStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(l10n.displayGroupErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
        ],
        child: BlocBuilder<DisplayGroupBloc, DisplayGroupState>(
          builder: (context, state) {
            if (state.participants.isEmpty) {
              if (state.status == DisplayGroupStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != DisplayGroupStatus.success) {
                return const SizedBox();
              } else {
                return Center(
                  child: Text(
                    l10n.displayGroupEmptyText,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }
            }

            return ListView(
              children: [
                for (final participant in state.participants)
                  DisplayGroupListTile(
                    participant: participant,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
