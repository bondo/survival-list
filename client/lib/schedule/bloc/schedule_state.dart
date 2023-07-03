part of 'schedule_bloc.dart';

enum ScheduleStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  const ScheduleState({
    required this.variant,
    this.status = ScheduleStatus.initial,
    this.todos = const [],
    this.filter = ScheduleViewFilter.all,
    this.order = ScheduleViewOrder.byDate,
    this.userPhotoUrl,
    this.viewerPerson,
  });

  final ScheduleStatus status;
  final List<Item> todos;
  final ScheduleViewFilter filter;
  final ScheduleViewVariant variant;
  final ScheduleViewOrder order;
  final String? userPhotoUrl;
  final Person? viewerPerson;

  List<Item> get filteredItems =>
      variant.apply(filter.apply(todos, viewerPerson))..sort(order.compare);

  ScheduleState copyWith({
    ScheduleStatus Function()? status,
    List<Item> Function()? todos,
    ScheduleViewFilter Function()? filter,
    ScheduleViewOrder Function()? order,
    String? Function()? userPhotoUrl,
    Person? Function()? viewerPerson,
  }) {
    return ScheduleState(
      variant: variant,
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      order: order != null ? order() : this.order,
      userPhotoUrl: userPhotoUrl != null ? userPhotoUrl() : this.userPhotoUrl,
      viewerPerson: viewerPerson != null ? viewerPerson() : this.viewerPerson,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        order,
        userPhotoUrl,
        viewerPerson,
      ];
}
