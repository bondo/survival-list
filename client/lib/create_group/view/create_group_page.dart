import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/create_group/create_group.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => CreateGroupBloc(
          survivalListRepository: context.read<SurvivalListRepository>(),
        ),
        child: const CreateGroupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateGroupBloc, CreateGroupState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == CreateGroupStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const CreateGroupView(),
    );
  }
}

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((CreateGroupBloc bloc) => bloc.state.status);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createGroupAppBarTitle),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.createGroupSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context
                .read<CreateGroupBloc>()
                .add(const CreateGroupSubmitted()),
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
    final state = context.watch<CreateGroupBloc>().state;

    return TextFormField(
      key: const Key('createGroupView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        icon: const Icon(Icons.text_fields),
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.createGroupTitleLabel,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<CreateGroupBloc>().add(CreateGroupTitleChanged(value));
      },
    );
  }
}
