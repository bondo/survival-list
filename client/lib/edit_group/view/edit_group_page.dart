import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/edit_group/edit_group.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class EditGroupPage extends StatelessWidget {
  const EditGroupPage({super.key});

  static Route<void> route({required Group group}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditGroupBloc(
          survivalListRepository: context.read<SurvivalListRepository>(),
          group: group,
        ),
        child: const EditGroupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditGroupBloc, EditGroupState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditGroupStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditGroupView(),
    );
  }
}

class EditGroupView extends StatelessWidget {
  const EditGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditGroupBloc bloc) => bloc.state.status);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editGroupAppBarTitle),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editGroupSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () =>
                context.read<EditGroupBloc>().add(const EditGroupSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _TitleField(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditGroupBloc>().state;
    final hintText = state.group.title;

    return TextFormField(
      key: const Key('editGroupView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        icon: const Icon(Icons.text_fields),
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editGroupTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<EditGroupBloc>().add(EditGroupTitleChanged(value));
      },
    );
  }
}
