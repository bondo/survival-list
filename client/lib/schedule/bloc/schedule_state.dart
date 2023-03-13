part of 'schedule_bloc.dart';

enum ScheduleStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  const ScheduleState({
    this.status = ScheduleStatus.initial,
    this.todos = const [],
    this.filter = ScheduleViewFilter.all,
    this.lastDeletedItem,
  });

  final ScheduleStatus status;
  final List<Item> todos;
  final ScheduleViewFilter filter;
  final Item? lastDeletedItem;

  Iterable<Item> get filteredItems => filter.applyAll(todos);

  ScheduleState copyWith({
    ScheduleStatus Function()? status,
    List<Item> Function()? todos,
    ScheduleViewFilter Function()? filter,
    Item? Function()? lastDeletedItem,
  }) {
    return ScheduleState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedItem:
          lastDeletedItem != null ? lastDeletedItem() : this.lastDeletedItem,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        lastDeletedItem,
      ];
}
