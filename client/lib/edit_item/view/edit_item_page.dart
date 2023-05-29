import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/edit_item/edit_item.dart';
import 'package:survival_list/form_field_widgets/date.dart';
import 'package:survival_list/form_field_widgets/duration.dart';
import 'package:survival_list/form_field_widgets/group.dart';
import 'package:survival_list/form_field_widgets/person.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class EditItemPage extends StatelessWidget {
  const EditItemPage({super.key});

  static Route<void> route({required Item item}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditItemBloc(
          survivalListRepository: context.read<SurvivalListRepository>(),
          item: item,
        )
          ..add(const EditItemSubscriptionRequested())
          ..add(EditItemGroupParticipantsSubscriptionRequested(item.group)),
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
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editItemAppBarTitle),
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
      body: const CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _TitleField(),
                _StartDateField(),
                _EndDateField(),
                _EstimateField(),
                _GroupField(),
                _ResponsibleField()
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
    final state = context.watch<EditItemBloc>().state;
    final hintText = state.item.title;

    return TextFormField(
      key: const Key('editItemView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        icon: const Icon(Icons.text_fields),
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

class _StartDateField extends StatelessWidget {
  const _StartDateField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditItemBloc>().state;

    return DateFormField(
      value: state.startDate,
      lastDate: state.endDate,
      locale: l10n.localeName,
      onChanged: (pickedDate) {
        context.read<EditItemBloc>().add(EditItemStartDateChanged(pickedDate));
      },
      label: l10n.editItemStartDateLabel,
    );
  }
}

class _EndDateField extends StatelessWidget {
  const _EndDateField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditItemBloc>().state;

    return DateFormField(
      firstDate: state.startDate,
      value: state.endDate,
      locale: l10n.localeName,
      onChanged: (pickedDate) {
        context.read<EditItemBloc>().add(EditItemEndDateChanged(pickedDate));
      },
      label: l10n.editItemEndDateLabel,
    );
  }
}

class _GroupField extends StatelessWidget {
  const _GroupField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditItemBloc>().state;

    return state.group == null &&
            (state.groupsStatus != EditItemStatus.success ||
                state.groups.isEmpty)
        ? const SizedBox.shrink()
        : GroupFormField(
            value: state.group,
            options: state.groupsStatus == EditItemStatus.success
                ? state.groups
                : null,
            onChanged: (pickedGroup) {
              context
                  .read<EditItemBloc>()
                  .add(EditItemGroupChanged(pickedGroup));
            },
            label: l10n.editItemGroupLabel,
          );
  }
}

class _ResponsibleField extends StatelessWidget {
  const _ResponsibleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditItemBloc>().state;

    return state.group == null
        ? const SizedBox.shrink()
        : PersonFormField(
            value: state.responsible ?? state.viewerPerson,
            options: state.groupParticipantsStatus == EditItemStatus.success
                ? state.groupParticipants
                : null,
            onChanged: (pickedResponsible) {
              context
                  .read<EditItemBloc>()
                  .add(EditItemResponsibleChanged(pickedResponsible));
            },
            label: l10n.editItemResponsibleLabel,
          );
  }
}

class _EstimateField extends StatelessWidget {
  const _EstimateField();

  @override
  Widget build(BuildContext context) {
    return DurationFormField(
      initialValue: context.read<EditItemBloc>().state.estimate,
      onChanged: (pickedEstimate) {
        context
            .read<EditItemBloc>()
            .add(EditItemEstimateChanged(pickedEstimate));
      },
    );
  }
}
