part of 'create_item_bloc.dart';

abstract class CreateItemEvent extends Equatable {
  const CreateItemEvent();

  @override
  List<Object> get props => [];
}

class CreateItemTitleChanged extends CreateItemEvent {
  const CreateItemTitleChanged(this.title);

  final String title;

  @override
  List<Object> get props => [title];
}

class CreateItemStartDateChanged extends CreateItemEvent {
  const CreateItemStartDateChanged(this.startDate);

  final DateTime? startDate;

  @override
  List<Object> get props => [startDate ?? 'null'];
}

class CreateItemEndDateChanged extends CreateItemEvent {
  const CreateItemEndDateChanged(this.endDate);

  final DateTime? endDate;

  @override
  List<Object> get props => [endDate ?? 'null'];
}

class CreateItemEstimateChanged extends CreateItemEvent {
  const CreateItemEstimateChanged(this.estimate);

  final SimpleDuration estimate;

  @override
  List<Object> get props => [estimate];
}

class CreateItemGroupChanged extends CreateItemEvent {
  const CreateItemGroupChanged(this.group);

  final Group? group;

  @override
  List<Object> get props => [group ?? 'null'];
}

class CreateItemResponsibleChanged extends CreateItemEvent {
  const CreateItemResponsibleChanged(this.responsible);

  final Person? responsible;

  @override
  List<Object> get props => [responsible ?? 'null'];
}

class CreateItemSubmitted extends CreateItemEvent {
  const CreateItemSubmitted();
}

class CreateItemSubscriptionRequested extends CreateItemEvent {
  const CreateItemSubscriptionRequested();
}

class CreateItemGroupParticipantsSubscriptionRequested extends CreateItemEvent {
  const CreateItemGroupParticipantsSubscriptionRequested(this.group);

  final Group group;

  @override
  List<Object> get props => [group];
}
