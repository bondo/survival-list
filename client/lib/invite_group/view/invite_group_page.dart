import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:survival_list/invite_group/invite_group.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class InviteGroupPage extends StatelessWidget {
  const InviteGroupPage({super.key});

  static Route<void> route({required Group group}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (_) => InviteGroupCubit(group),
        child: const InviteGroupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const InviteGroupView();
}

class InviteGroupView extends StatelessWidget {
  const InviteGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final group = context.select((InviteGroupCubit cubit) => cubit.state.group);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.inviteGroupAppBarTitle(group.title)),
      ),
      body: Center(
        child: QrImage(data: 'survival-list:${group.uid}'),
      ),
    );
  }
}
