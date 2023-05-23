part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class ScheduleSubscriptionRequested extends ScheduleEvent {
  const ScheduleSubscriptionRequested();
}

class ScheduleItemCompletionToggled extends ScheduleEvent {
  const ScheduleItemCompletionToggled({
    required this.item,
    required this.isCompleted,
  });

  final Item item;
  final bool isCompleted;

  @override
  List<Object> get props => [item, isCompleted];
}

class ScheduleItemDeleted extends ScheduleEvent {
  const ScheduleItemDeleted(this.item);

  final Item item;

  @override
  List<Object> get props => [item];
}

class ScheduleUndoDeletionRequested extends ScheduleEvent {
  const ScheduleUndoDeletionRequested();
}

class ScheduleFilterChanged extends ScheduleEvent {
  const ScheduleFilterChanged(this.filter);

  final ScheduleViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class ScheduleLogoutRequested extends ScheduleEvent {
  const ScheduleLogoutRequested();
}

class ScheduleRefreshRequested extends ScheduleEvent {
  const ScheduleRefreshRequested();
}
