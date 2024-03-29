part of 'edit_item_bloc.dart';

abstract class EditItemEvent extends Equatable {
  const EditItemEvent();

  @override
  List<Object> get props => [];
}

class DeleteItem extends EditItemEvent {
  const DeleteItem();
}

class EditItemTitleChanged extends EditItemEvent {
  const EditItemTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class EditItemStartDateChanged extends EditItemEvent {
  const EditItemStartDateChanged(this.startDate);

  final DateTime? startDate;

  @override
  List<Object> get props => [startDate ?? 'null'];
}

class EditItemEndDateChanged extends EditItemEvent {
  const EditItemEndDateChanged(this.endDate);

  final DateTime? endDate;

  @override
  List<Object> get props => [endDate ?? 'null'];
}

class EditItemEstimateChanged extends EditItemEvent {
  const EditItemEstimateChanged(this.estimate);

  final ShortDuration estimate;

  @override
  List<Object> get props => [estimate];
}

class EditItemRecurrenceKindChanged extends EditItemEvent {
  const EditItemRecurrenceKindChanged(this.kind);

  final RecurrenceKind kind;

  @override
  List<Object> get props => [kind];
}

class EditItemRecurrenceFrequencyChanged extends EditItemEvent {
  const EditItemRecurrenceFrequencyChanged(this.frequency);

  final LongDuration frequency;

  @override
  List<Object> get props => [frequency];
}

class EditItemGroupChanged extends EditItemEvent {
  const EditItemGroupChanged(this.group);

  final Group? group;

  @override
  List<Object> get props => [group ?? 'null'];
}

class EditItemResponsibleChanged extends EditItemEvent {
  const EditItemResponsibleChanged(this.responsible);

  final Person? responsible;

  @override
  List<Object> get props => [responsible ?? 'null'];
}

class EditItemSubmitted extends EditItemEvent {
  const EditItemSubmitted();
}

class EditItemSubscriptionRequested extends EditItemEvent {
  const EditItemSubscriptionRequested();
}

class EditItemGroupParticipantsSubscriptionRequested extends EditItemEvent {
  const EditItemGroupParticipantsSubscriptionRequested(this.group);

  final Group? group;

  @override
  List<Object> get props => [group ?? 'null'];
}
