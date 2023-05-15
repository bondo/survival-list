part of 'schedule_bloc.dart';

enum ScheduleStatus { initial, loading, success, failure }

class ScheduleState extends Equatable {
  const ScheduleState({
    required this.variant,
    this.status = ScheduleStatus.initial,
    this.todos = const [],
    this.filter = ScheduleViewFilter.all,
    this.lastDeletedItem,
    this.userPhotoUrl,
    this.viewerPerson,
  });

  final ScheduleStatus status;
  final List<Item> todos;
  final ScheduleViewFilter filter;
  final ScheduleViewVariant variant;
  final Item? lastDeletedItem;
  final String? userPhotoUrl;
  final Person? viewerPerson;

  List<Item> get filteredItems => variant.apply(filter.apply(todos));

  ScheduleState copyWith({
    ScheduleStatus Function()? status,
    List<Item> Function()? todos,
    ScheduleViewFilter Function()? filter,
    Item? Function()? lastDeletedItem,
    String? Function()? userPhotoUrl,
    Person? Function()? viewerPerson,
  }) {
    return ScheduleState(
      variant: variant,
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
      lastDeletedItem:
          lastDeletedItem != null ? lastDeletedItem() : this.lastDeletedItem,
      userPhotoUrl: userPhotoUrl != null ? userPhotoUrl() : this.userPhotoUrl,
      viewerPerson: viewerPerson != null ? viewerPerson() : this.viewerPerson,
    );
  }

  @override
  List<Object?> get props => [
        status,
        todos,
        filter,
        lastDeletedItem,
        userPhotoUrl,
        viewerPerson,
      ];
}
