import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survival_list/create_item/create_item.dart';
import 'package:survival_list/form_field_widgets/date.dart';
import 'package:survival_list/form_field_widgets/group.dart';
import 'package:survival_list/form_field_widgets/long_duration.dart';
import 'package:survival_list/form_field_widgets/person.dart';
import 'package:survival_list/form_field_widgets/recurrence_kind.dart';
import 'package:survival_list/form_field_widgets/short_duration.dart';
import 'package:survival_list/l10n/l10n.dart';
import 'package:survival_list_repository/survival_list_repository.dart';

class CreateItemPage extends StatelessWidget {
  const CreateItemPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => CreateItemBloc(
          survivalListRepository: context.read<SurvivalListRepository>(),
        )..add(const CreateItemSubscriptionRequested()),
        child: const CreateItemPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateItemBloc, CreateItemState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == CreateItemStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const CreateItemView(),
    );
  }
}

class CreateItemView extends StatelessWidget {
  const CreateItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((CreateItemBloc bloc) => bloc.state.status);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.createItemAppBarTitle),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.createItemSaveButtonTooltip,
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isLoadingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isLoadingOrSuccess
            ? null
            : () =>
                context.read<CreateItemBloc>().add(const CreateItemSubmitted()),
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
                _RecurrenceKindField(),
                _RecurrenceFrequencyField(),
                _GroupField(),
                _ResponsibleField(),
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
    final state = context.watch<CreateItemBloc>().state;

    return TextFormField(
      key: const Key('createItemView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        icon: const Icon(Icons.text_fields),
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.createItemTitleLabel,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
        FilteringTextInputFormatter.deny(
          RegExp(r'[\p{Zl}\p{Zp}\p{C}]', unicode: true),
        ),
      ],
      onChanged: (value) {
        context.read<CreateItemBloc>().add(CreateItemTitleChanged(value));
      },
    );
  }
}

class _StartDateField extends StatelessWidget {
  const _StartDateField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CreateItemBloc>().state;

    return DateFormField(
      value: state.startDate,
      lastDate: state.endDate,
      locale: l10n.localeName,
      helperText: l10n.createItemStartDateHelperText,
      onChanged: (pickedDate) {
        context
            .read<CreateItemBloc>()
            .add(CreateItemStartDateChanged(pickedDate));
      },
      label: l10n.createItemStartDateLabel,
    );
  }
}

class _EndDateField extends StatelessWidget {
  const _EndDateField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CreateItemBloc>().state;

    return DateFormField(
      firstDate: state.startDate,
      value: state.endDate,
      locale: l10n.localeName,
      helperText: l10n.createItemEndDateHelperText,
      onChanged: (pickedDate) {
        context
            .read<CreateItemBloc>()
            .add(CreateItemEndDateChanged(pickedDate));
      },
      label: l10n.createItemEndDateLabel,
    );
  }
}

class _GroupField extends StatelessWidget {
  const _GroupField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CreateItemBloc>().state;

    return (state.groupsStatus != CreateItemStatus.success ||
            state.groups.isEmpty)
        ? const SizedBox.shrink()
        : GroupFormField(
            value: state.group,
            options: state.groupsStatus == CreateItemStatus.success
                ? state.groups
                : null,
            onChanged: (pickedGroup) {
              context
                  .read<CreateItemBloc>()
                  .add(CreateItemGroupChanged(pickedGroup));
            },
            label: l10n.createItemGroupLabel,
            viewerPerson: state.viewerPerson,
          );
  }
}

class _ResponsibleField extends StatelessWidget {
  const _ResponsibleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CreateItemBloc>().state;

    return state.group == null
        ? const SizedBox.shrink()
        : PersonFormField(
            value: state.responsible ?? state.viewerPerson,
            options: state.groupParticipantsStatus == CreateItemStatus.success
                ? state.groupParticipants
                : null,
            onChanged: (pickedResponsible) {
              context
                  .read<CreateItemBloc>()
                  .add(CreateItemResponsibleChanged(pickedResponsible));
            },
            label: l10n.createItemResponsibleLabel,
          );
  }
}

class _EstimateField extends StatelessWidget {
  const _EstimateField();

  @override
  Widget build(BuildContext context) {
    return ShortDurationFormField(
      initialValue: context.read<CreateItemBloc>().state.estimate,
      onChanged: (pickedEstimate) {
        context
            .read<CreateItemBloc>()
            .add(CreateItemEstimateChanged(pickedEstimate));
      },
    );
  }
}

class _RecurrenceKindField extends StatelessWidget {
  const _RecurrenceKindField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<CreateItemBloc>().state;

    return RecurrenceKindFormField(
      value: state.recurrenceKind,
      onChanged: (pickedRecurrenceKind) {
        context
            .read<CreateItemBloc>()
            .add(CreateItemRecurrenceKindChanged(pickedRecurrenceKind));
      },
      label: l10n.createItemRecurrenceKindLabel,
    );
  }
}

class _RecurrenceFrequencyField extends StatelessWidget {
  const _RecurrenceFrequencyField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreateItemBloc>().state;

    return state.recurrenceKind == RecurrenceKind.none
        ? const SizedBox.shrink()
        : LongDurationFormField(
            initialValue:
                context.read<CreateItemBloc>().state.recurrenceFrequency,
            onChanged: (pickedRecurrenceFrequency) {
              context.read<CreateItemBloc>().add(
                    CreateItemRecurrenceFrequencyChanged(
                      pickedRecurrenceFrequency,
                    ),
                  );
            },
          );
  }
}
