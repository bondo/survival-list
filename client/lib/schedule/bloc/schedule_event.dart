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

class ScheduleFilterChanged extends ScheduleEvent {
  const ScheduleFilterChanged(this.filter);

  final ScheduleViewFilter filter;

  @override
  List<Object> get props => [filter];
}

class ScheduleOrderChanged extends ScheduleEvent {
  const ScheduleOrderChanged(this.order);

  final ScheduleViewOrder order;

  @override
  List<Object> get props => [order];
}

class ScheduleLogoutRequested extends ScheduleEvent {
  const ScheduleLogoutRequested();
}

class ScheduleRefreshRequested extends ScheduleEvent {
  const ScheduleRefreshRequested();
}
