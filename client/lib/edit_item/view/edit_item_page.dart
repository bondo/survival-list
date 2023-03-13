import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/edit_item/edit_item.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  static Route<void> route({Item? initialItem}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditItemBloc(
          survivalListRepository: context.read<SurvivalListRepository>(),
          initialItem: initialItem,
        ),
        child: const EditItemPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditItemBloc, EditItemState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditItemStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditItemView(),
    );
  }
}

class EditItemView extends StatelessWidget {
  const EditItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditItemBloc bloc) => bloc.state.status);
    final isNewItem = context.select(
      (EditItemBloc bloc) => bloc.state.isNewItem,
    );
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewItem
              ? l10n.editItemAddAppBarTitle
              : l10n.editItemEditAppBarTitle,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.editItemSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () => context.read<EditItemBloc>().add(const EditItemSubmitted()),
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [_TitleField()],
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
    final state = context.watch<EditItemBloc>().state;
    final hintText = state.initialItem?.title ?? '';

    return TextFormField(
      key: const Key('editItemView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editItemTitleLabel,
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
      ],
      onChanged: (value) {
        context.read<EditItemBloc>().add(EditItemTitleChanged(value));
      },
    );
  }
}
